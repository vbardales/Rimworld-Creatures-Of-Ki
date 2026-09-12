<#
.SYNOPSIS
  What the game actually does with this mod's defs, checked outside the game.

.DESCRIPTION
  TESTS.md next door is the other half of this: seven scenarios to play, which is the only way to
  see the animal drawn and the only way to watch an egg hatch. This file asks the questions that do
  not need the game running, and answers them from the compiled game rather than from a claim in a
  document.

  The mod ships no assembly. Four defs and nine textures hand the whole animal to vanilla classes,
  so the question is whether those classes still do what the defs hand to them - and in particular
  whether the two changes the 1.6 port made were the right ones.

  Nothing here is simulated. RimWorld cannot run outside itself: ThingDef will not even
  instantiate, and the XML loader is out of reach. Three things do work, and they are enough:

    reflection     the shape of the game's own types - a field that no longer exists is the whole
                   reason the port had to move wildness to a stat.
    reading IL     a method body comes back as bytes and its field tokens resolve. The gate that
                   decides whether a lone female ever lays is read off CompEggLayer, not assumed.
    reverse lookup one pass over every method of Assembly-CSharp says WHO reads each field this
                   mod writes. Sixteen thousand types in a few seconds.

  Four groups of tests:

    The port's two changes   the vanished wildness field, the stat that replaced it, and the two
                             paths that reach the unfertilized egg
    No setting inert         every field the defs write has a reader left in 1.6
    The textures             nine files, three facings each, compared case by case
    What it leans on         the vanilla bases, the body it declares, and the defs it names

  Three findings worth keeping, all three from writing this:

    - RaceProperties has no wildness field in 1.6. The pre-1.6 form was not an error and produced
      no warning; it was simply never read, which is why a teshi tamed like a rat.
    - CompEggLayer.ProduceEgg and NextEggType both read eggUnfertilizedDef. With eggCountRange 2
      and eggFertilizationCountMax 1, a mated laying reaches it, so the def this port added is
      needed whatever happens to a lone female.
    - and the lone female is settled here, which TESTS.md scenario 4b could not settle without
      playing: ProgressStoppedBecauseUnfertilized arms only when eggProgressUnfertilizedMax is
      below 1, the teshi's is 0.9, and CompTick reads the same field. Her progress stops at 90 %
      and she never lays at all.

  What this file CANNOT check, and does not pretend to: the game ships no loose textures - Core has
  only About, Defs and Languages on disk - so the dessicated sprite this mod borrows from the
  dromedary cannot be resolved here. TESTS.md scenario 6 is the only check for it.

  Exit code 0 when everything passes, 1 otherwise. A few seconds.

  SIXTEEN OF THE SEVENTEEN HAVE BEEN SEEN TO FAIL, one fault at a time, in a copy of the mod in a
  scratch directory and never in the real files. The list is at the foot of this file, and so is
  the one that could not be: it can only go red if the GAME changes, and nothing here patches the
  game to find out.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
#>

param(
    [string]$ModRoot  = (Split-Path -Parent $PSScriptRoot),
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data',
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed'
)

$ErrorActionPreference = 'Stop'

$script:ran = 0
$script:failed = 0

function It([string]$name, [scriptblock]$body) {
    $script:ran++
    $problems = @()
    try   { $problems = @(& $body | Where-Object { $_ }) }
    catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    if ($problems.Count -eq 0) { Write-Output "  ok    $name" }
    else {
        $script:failed++
        Write-Output "  FAIL  $name"
        foreach ($p in $problems) { Write-Output "          $p" }
    }
}

function Section([string]$name) { Write-Output ''; Write-Output $name }

# ---------------------------------------------------------------------------------------------
# The game, loaded
# ---------------------------------------------------------------------------------------------
#
# Assembly-CSharp.GetTypes() always throws here - Unity is missing - and the types that did load
# come back on the exception. Losing that catch is not a small bug: every lookup then returns null,
# and a test written as "there is no field called wildness" reports a pass it never earned. That
# happened while writing this file, which is why the type count is asserted before anything else.

# The handler outlives the script unless it is taken back off, and once the script scope is gone
# every variable it reads comes back null: the host session then answers each later resolution
# with a page of errors from these four lines. It is removed at the end of the run, and the guard
# below covers the run that ends by throwing before it gets there.

$script:probed = @{}
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if (-not $script:probed -or -not $Managed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    $p = Join-Path $Managed "$short.dll"
    if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

function Get-AssemblyTypes([string]$path) {
    $a = [System.Reflection.Assembly]::LoadFrom($path)
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$allTypes = @()
$byName   = @{}
$asmPath  = Join-Path $Managed 'Assembly-CSharp.dll'
if (Test-Path $asmPath) {
    $allTypes = @(Get-AssemblyTypes $asmPath)
    foreach ($t in $allTypes) { if (-not $byName.ContainsKey($t.Name)) { $byName[$t.Name] = $t } }
}

$BFd = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,DeclaredOnly'
$BFm = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static,DeclaredOnly'
$BFa = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'

function Get-FieldsRecursive([Type]$t) {
    $d = @{}
    $cur = $t
    while ($cur -and $cur.FullName -ne 'System.Object') {
        foreach ($f in $cur.GetFields($BFd)) { if (-not $d.ContainsKey($f.Name)) { $d[$f.Name] = $f } }
        $cur = $cur.BaseType
    }
    return $d
}

Write-Output 'Creatures of Ki - Teshi Renew: what the game does with these defs'
Write-Output "  Assembly-CSharp: $($allTypes.Count) types"

# ---------------------------------------------------------------------------------------------
# What the mod writes
# ---------------------------------------------------------------------------------------------

$modDir  = Join-Path $ModRoot 'Mod'
$defFiles = @(Get-ChildItem (Join-Path $modDir 'Defs') -Recurse -Filter *.xml | Sort-Object FullName)

$defNodes = @()
foreach ($f in $defFiles) {
    $x = New-Object System.Xml.XmlDocument
    $x.Load($f.FullName)
    if ($null -eq $x.DocumentElement -or $x.DocumentElement.LocalName -ne 'Defs') { continue }
    foreach ($n in $x.DocumentElement.ChildNodes) {
        if ($n.NodeType -eq 'Element') { $defNodes += $n }
    }
}

function Get-Text($node, [string]$xpath) {
    if (-not $node) { return $null }
    $n = $node.SelectSingleNode($xpath)
    if ($n) { return $n.InnerText.Trim() }
    return $null
}

# The defs are taken by TYPE and by the base they inherit from, never by defName: a test about a
# defName cannot hold its def by that name, or breaking the name is reported as "the mod declares
# none" instead of as the fault it is.
$teshiNode = $null; $kindNode = $null; $bodyNode = $null; $fertNode = $null; $unfertNode = $null
foreach ($n in $defNodes) {
    switch ($n.LocalName) {
        'PawnKindDef' { $kindNode = $n }
        'BodyDef'     { $bodyNode = $n }
        'ThingDef'    {
            switch ($n.GetAttribute('ParentName')) {
                'EggFertBase'     { $fertNode = $n }
                'EggUnfertBase'   { $unfertNode = $n }
                'AnimalThingBase' { $teshiNode = $n }
            }
        }
    }
}

$eggComp = $null
if ($teshiNode) {
    foreach ($li in $teshiNode.SelectNodes('comps/li')) {
        if ($li.GetAttribute('Class') -ceq 'CompProperties_EggLayer') { $eggComp = $li }
    }
}

# Every field the defs set, resolved to the FieldInfo the game's loader would fill. The walk stops
# at generic fields - a List<T> in XML is a list of names, or of sub-objects with a loader of their
# own - and the three lists that carry settings here are walked explicitly afterwards.
$written = @{}
function Collect-Written($node, [Type]$t) {
    if (-not $t) { return }
    $fields = Get-FieldsRecursive $t
    foreach ($c in $node.ChildNodes) {
        if ($c.NodeType -ne 'Element' -or $c.LocalName -ceq 'li') { continue }
        $f = $fields[$c.LocalName]
        if (-not $f) { continue }
        # Keyed by the type that DECLARES the field. defName written under a PawnKindDef is
        # Def.defName, read by half the game and a setting of nobody's; keeping the declaring type
        # is what lets the inert-setting test single out this mod's real settings.
        $written[$f.MetadataToken] = "$($f.DeclaringType.Name).$($f.Name)"
        $ft = $f.FieldType
        if ($ft.IsPrimitive -or $ft -eq [string] -or $ft.IsEnum -or $ft.IsGenericType) { continue }
        if ($byName['Def'] -and $byName['Def'].IsAssignableFrom($ft)) { continue }
        $sub = $ft
        $cls = $c.GetAttribute('Class')
        if ($cls -and $byName.ContainsKey($cls)) { $sub = $byName[$cls] }
        Collect-Written $c $sub
    }
}

if ($byName.Count -gt 0) {
    foreach ($n in $defNodes) { Collect-Written $n $byName[$n.LocalName] }
    foreach ($owner in @($teshiNode, $fertNode, $unfertNode)) {
        if (-not $owner) { continue }
        foreach ($li in @($owner.SelectNodes('comps/li'))) {
            $cls = $li.GetAttribute('Class')
            $t = $(if ($cls -and $byName.ContainsKey($cls)) { $byName[$cls] } else { $byName['CompProperties'] })
            Collect-Written $li $t
        }
    }
    if ($teshiNode) { foreach ($li in @($teshiNode.SelectNodes('tools/li')))     { Collect-Written $li $byName['Tool'] } }
    if ($kindNode)  { foreach ($li in @($kindNode.SelectNodes('lifeStages/li'))) { Collect-Written $li $byName['PawnKindLifeStage'] } }
}

# ---------------------------------------------------------------------------------------------
# Who reads what: one pass over every method body in the game
# ---------------------------------------------------------------------------------------------
#
# ldfld is 0x7B and carries a four-byte token. Inside one module that token IS the field's
# MetadataToken, so the scan is an integer comparison and no member is resolved per instruction.
# The reader is recorded as the OUTERMOST declaring type: a state machine compiles to a nested
# <CompTick>d__7 and a lambda to a <>c, and reporting those would name nothing recognisable.

$readers = @{}
$readersByMethod = @{}
$scanSeconds = 0
if ($written.Count -gt 0) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    foreach ($t in $allTypes) {
        foreach ($m in (@($t.GetMethods($BFm)) + @($t.GetConstructors($BFm)))) {
            $body = $null
            try { $body = $m.GetMethodBody() } catch { }
            if (-not $body) { continue }
            $il = $body.GetILAsByteArray()
            if (-not $il -or $il.Length -lt 5) { continue }
            for ($i = 0; $i -lt $il.Length - 4; $i++) {
                if ($il[$i] -ne 0x7B) { continue }
                $tok = [BitConverter]::ToInt32($il, $i + 1)
                if (-not $written.ContainsKey($tok)) { continue }
                $owner = $t
                while ($owner.DeclaringType) { $owner = $owner.DeclaringType }
                $key = $written[$tok]
                if (-not $readers.ContainsKey($key)) { $readers[$key] = @{} }
                $readers[$key][$owner.Name] = $true
                if (-not $readersByMethod.ContainsKey($key)) { $readersByMethod[$key] = @{} }
                $readersByMethod[$key]["$($owner.Name).$($m.Name)"] = $true
            }
        }
    }
    $sw.Stop()
    $scanSeconds = [math]::Round($sw.Elapsed.TotalSeconds, 1)
}

function Get-Readers([string]$field) {
    if ($readers.ContainsKey($field)) { return @($readers[$field].Keys | Sort-Object) }
    return @()
}
function Get-ReaderMethods([string]$field) {
    if ($readersByMethod.ContainsKey($field)) { return @($readersByMethod[$field].Keys | Sort-Object) }
    return @()
}
function Show-Some($names) {
    $a = @($names)
    if ($a.Count -le 6) { return ($a -join ', ') }
    return (($a[0..5] -join ', ') + " and $($a.Count - 6) more")
}

# ---------------------------------------------------------------------------------------------
# The vanilla defs, read from Data
# ---------------------------------------------------------------------------------------------

$vanillaNamed = @{}
$vanillaAbstract = @{}
foreach ($dir in (Get-ChildItem $GameData -Directory)) {
    $defsRoot = Join-Path $dir.FullName 'Defs'
    if (-not (Test-Path $defsRoot)) { continue }
    foreach ($f in Get-ChildItem $defsRoot -Recurse -Filter *.xml) {
        $x = New-Object System.Xml.XmlDocument
        try { $x.Load($f.FullName) } catch { continue }
        if ($null -eq $x.DocumentElement -or $x.DocumentElement.LocalName -ne 'Defs') { continue }
        foreach ($n in $x.DocumentElement.ChildNodes) {
            if ($n.NodeType -ne 'Element') { continue }
            $nm = $n.GetAttribute('Name')
            if ($nm) { $vanillaAbstract[$nm] = $n.LocalName }
            $dn = Get-Text $n 'defName'
            if ($dn) { $vanillaNamed["$($n.LocalName)/$dn"] = $n }
        }
    }
}

function Has-Vanilla([string]$type, [string]$defName) { return $vanillaNamed.ContainsKey("$type/$defName") }

Write-Output "  Data: $($vanillaNamed.Count) named defs, $($vanillaAbstract.Count) abstract bases"
Write-Output "  mod: $($defNodes.Count) defs, $($written.Count) fields written, scan $scanSeconds s"

# =============================================================================================
Section 'The harness itself'
# =============================================================================================
#
# Not ceremony. Every group below reports "nothing wrong" when its inputs are empty, so the inputs
# are asserted first.

It 'the game and its data are actually loaded' {
    if ($allTypes.Count -lt 10000)      { "Assembly-CSharp gave $($allTypes.Count) types; expected some sixteen thousand. Every lookup below would return null and pass." }
    if (-not $byName['RaceProperties']) { 'RaceProperties not found: the type table is empty, or the game moved it.' }
    if ($vanillaNamed.Count -lt 5000)   { "Data gave $($vanillaNamed.Count) defs; expected thousands. Check -GameData." }
    if ($written.Count -lt 40)          { "only $($written.Count) written fields were resolved; the walk over the defs is broken." }
    foreach ($pair in @(
        ,@('the animal',           $teshiNode)
        ,@('its pawn kind',        $kindNode)
        ,@('its body',             $bodyNode)
        ,@('the fertilized egg',   $fertNode)
        ,@('the unfertilized egg', $unfertNode)
        ,@('the egg-layer comp',   $eggComp)
    )) { if (-not $pair[1]) { "$($pair[0]) was not found in the mod's defs." } }
}

# =============================================================================================
Section "The port's two changes, read off the game"
# =============================================================================================

It 'RaceProperties has no wildness field, so the pre-1.6 form could only be ignored' {
    $rp = $byName['RaceProperties']
    $wild = @($rp.GetFields($BFa) | Where-Object { $_.Name -ceq 'wildness' })
    if ($wild.Count -gt 0) { 'RaceProperties.wildness exists in this build: the first of the two port changes is unnecessary, and the value belongs under <race> after all.' }
    if ($teshiNode.SelectSingleNode('race/wildness')) { 'the def still writes <wildness> under <race>, where nothing would read it.' }
}

It 'Wildness is declared as a stat, and 0.50 is a value that stat accepts' {
    $w = Get-Text $teshiNode 'statBases/Wildness'
    if (-not $w) { return 'the def declares no Wildness under statBases, so a wild teshi would take the stat default.' }
    if (-not $byName['StatDefOf'].GetField('Wildness', $BFa)) { 'StatDefOf.Wildness is gone: taming no longer reads this stat.' }
    $sd = $vanillaNamed['StatDef/Wildness']
    if (-not $sd) { return 'the game declares no Wildness StatDef.' }
    $v = [double]$w
    $min = Get-Text $sd 'minValue'
    $max = Get-Text $sd 'maxValue'
    if ($min -and $v -lt [double]$min) { "Wildness $v is below the stat's minValue $min." }
    if ($max -and $v -gt [double]$max) { "Wildness $v is above the stat's maxValue $max." }
    $def = Get-Text $sd 'defaultBaseValue'
    if ($def -and [double]$def -eq $v) { "Wildness $v is the stat's own default, so declaring it changes nothing." }
}

It 'the unfertilized egg is reached on a mated laying, by two methods of CompEggLayer' {
    $f = 'CompProperties_EggLayer.eggUnfertilizedDef'
    $m = Get-ReaderMethods $f
    if ($m.Count -eq 0) { return "nothing in the game reads $f any more: the def this port added would be inert." }
    foreach ($want in @('CompEggLayer.ProduceEgg', 'CompEggLayer.NextEggType')) {
        if ($m -notcontains $want) { "$f is no longer read by $want; its readers are now $(Show-Some $m)." }
    }
    $count = Get-Text $eggComp 'eggCountRange'
    $fert  = Get-Text $eggComp 'eggFertilizationCountMax'
    if (-not $count -or -not $fert) { return 'the comp no longer sets both eggCountRange and eggFertilizationCountMax.' }
    $low = [int](($count -split '~')[0])
    if ($low -le [int]$fert) { "eggCountRange $count is not above eggFertilizationCountMax $fert, so every egg of a laying can be fertilized and this path never reaches the unfertilized def." }
}

It 'a lone female never lays: the gate arms below 1, and this animal sits at 0.9' {
    # ProgressStoppedBecauseUnfertilized opens by comparing the setting against 1.0: at 1 or above
    # the gate is disarmed and an unmated female runs all the way to a laying. That constant is read
    # off the compiled property rather than taken from a wiki.
    $ce = $byName['CompEggLayer']
    $g = $ce.GetProperty('ProgressStoppedBecauseUnfertilized', $BFa)
    if (-not $g) { return 'CompEggLayer.ProgressStoppedBecauseUnfertilized is gone; the gate this conclusion rests on has been rewritten.' }
    $il = $g.GetGetMethod($true).GetMethodBody().GetILAsByteArray()
    $fld = $byName['CompProperties_EggLayer'].GetField('eggProgressUnfertilizedMax', $BFa)
    $found = $false
    for ($i = 0; $i -lt $il.Length - 9; $i++) {
        if ($il[$i] -ne 0x7B) { continue }
        if ([BitConverter]::ToInt32($il, $i + 1) -ne $fld.MetadataToken) { continue }
        # ldfld <field> ; ldc.r4 1.0  ->  0x22 and the four bytes of 1.0f
        if ($il[$i + 5] -eq 0x22 -and [BitConverter]::ToSingle($il, $i + 6) -eq 1.0) { $found = $true }
    }
    if (-not $found) { 'the property no longer compares eggProgressUnfertilizedMax against 1.0: the threshold that disarms the gate has moved.' }
    if ((Get-ReaderMethods 'CompProperties_EggLayer.eggProgressUnfertilizedMax') -notcontains 'CompEggLayer.CompTick') {
        'CompTick no longer reads eggProgressUnfertilizedMax, so progress is no longer held back by it.'
    }
    # The chain that settles it, in two instructions of the game's own code:
    #   CompTick  : ldfld eggProgressUnfertilizedMax ; stfld eggProgress   - progress is PINNED to
    #               the setting while the animal is unfertilized, not merely compared against it
    #   CanLayNow : ldfld eggProgress ; ldc.r4 1                           - laying needs a full 1
    # Pinned at 0.9 and needing 1, a lone female never lays at all.
    $prog = $ce.GetField('eggProgress', $BFa)
    $tick = $ce.GetMethod('CompTick', $BFa).GetMethodBody().GetILAsByteArray()
    $pinned = $false
    for ($i = 0; $i -lt $tick.Length - 10; $i++) {
        if ($tick[$i] -ne 0x7B) { continue }
        if ([BitConverter]::ToInt32($tick, $i + 1) -ne $fld.MetadataToken) { continue }
        if ($tick[$i + 5] -eq 0x7D -and [BitConverter]::ToInt32($tick, $i + 6) -eq $prog.MetadataToken) { $pinned = $true }
    }
    if (-not $pinned) { 'CompTick no longer writes eggProgressUnfertilizedMax straight into eggProgress; progress is no longer pinned to the setting, so a lone female may now reach a laying.' }
    $lay = $ce.GetProperty('CanLayNow', $BFa).GetGetMethod($true).GetMethodBody().GetILAsByteArray()
    $needsOne = $false
    for ($i = 0; $i -lt $lay.Length - 9; $i++) {
        if ($lay[$i] -ne 0x7B) { continue }
        if ([BitConverter]::ToInt32($lay, $i + 1) -ne $prog.MetadataToken) { continue }
        if ($lay[$i + 5] -eq 0x22 -and [BitConverter]::ToSingle($lay, $i + 6) -eq 1.0) { $needsOne = $true }
    }
    if (-not $needsOne) { 'CanLayNow no longer requires a full 1 of eggProgress; the threshold a pinned female cannot reach has moved.' }
    $p = Get-Text $eggComp 'eggProgressUnfertilizedMax'
    if (-not $p) { return 'the comp no longer sets eggProgressUnfertilizedMax; it would inherit, and the conclusion below would not hold.' }
    if ([double]$p -ge 1.0) { "eggProgressUnfertilizedMax is $p, which disarms the gate: a lone female WILL lay, and TESTS.md scenario 4b is written the wrong way round." }
}

It 'the fertilized egg hatches into this mod own animal' {
    $hatch = $null
    foreach ($li in $fertNode.SelectNodes('comps/li')) {
        if ($li.GetAttribute('Class') -ceq 'CompProperties_Hatcher') { $hatch = $li }
    }
    if (-not $hatch) { return 'the fertilized egg has no CompProperties_Hatcher.' }
    $pawn = Get-Text $hatch 'hatcherPawn'
    if (-not $pawn) { return 'the hatcher names no hatcherPawn.' }
    $kindName = Get-Text $kindNode 'defName'
    if ($pawn -cne $kindName) { "hatcherPawn is '$pawn' but this mod's PawnKindDef is '$kindName', and nothing else declares that name." }
    if ((Get-ReaderMethods 'CompProperties_Hatcher.hatcherPawn').Count -eq 0) { 'nothing reads CompProperties_Hatcher.hatcherPawn any more.' }
    if (-not (Get-Text $hatch 'hatcherDaystoHatch')) { 'the hatcher names no hatcherDaystoHatch, so the egg would hatch on the inherited default.' }
}

# =============================================================================================
Section 'No setting inert'
# =============================================================================================

It 'every field these defs write still has a reader in the game' {
    # The rule: a def that writes a field the game no longer reads is writing a comment. The fields
    # of Def itself are excluded - they are not settings of this mod.
    $skip = @('Def.defName', 'Def.label', 'Def.description', 'Def.generated', 'Def.modExtensions')
    $dead = @()
    foreach ($k in ($written.Values | Sort-Object -Unique)) {
        if ($skip -contains $k) { continue }
        if ((Get-Readers $k).Count -eq 0) { $dead += $k }
    }
    if ($dead.Count -gt 0) { "written but read by nothing in 1.6: $($dead -join ', ')" }
}

It 'the egg-layer settings are read by the egg-layer comp, not by something else' {
    foreach ($name in @('eggFertilizedDef', 'eggUnfertilizedDef', 'eggFertilizationCountMax', 'eggLayIntervalDays', 'eggProgressUnfertilizedMax')) {
        $field = "CompProperties_EggLayer.$name"
        $r = Get-Readers $field
        if ($r.Count -eq 0) { "$field has no reader at all." }
        elseif ($r -notcontains 'CompEggLayer') { "$field is read by $(Show-Some $r), but not by CompEggLayer." }
    }
}

It 'the tools name body part groups this mod own body puts on a part' {
    $groups = @{}
    foreach ($g in $bodyNode.SelectNodes('.//groups/li')) { $groups[$g.InnerText.Trim()] = $true }
    $used = 0
    foreach ($t in $teshiNode.SelectNodes('tools/li')) {
        $g = Get-Text $t 'linkedBodyPartsGroup'
        if (-not $g) { continue }
        $used++
        if (-not (Has-Vanilla 'BodyPartGroupDef' $g)) { "tool group '$g' is no BodyPartGroupDef in the game." }
        if (-not $groups.ContainsKey($g)) {
            "tool group '$g' is on no part of $(Get-Text $bodyNode 'defName'): the tool would never be usable, and nothing says so at load."
        }
    }
    if ($used -eq 0) { 'no tool names a body part group; the animal would have no attacks.' }
}

It 'the body part coverages leave room, parent by parent' {
    # The game requires the children of a part to cover no more than the whole of it. Computed
    # rather than tabulated, so it stays true when the body is edited.
    $bad = @()
    foreach ($parts in $bodyNode.SelectNodes('.//parts')) {
        $sum = 0.0
        $kids = @()
        foreach ($li in $parts.SelectNodes('li')) {
            $c = Get-Text $li 'coverage'
            if ($null -eq $c) { continue }
            $sum += [double]$c
            $kids += (Get-Text $li 'def')
        }
        $owner = $parts.ParentNode
        $name = $(if ($owner.SelectSingleNode('def')) { Get-Text $owner 'def' } else { 'corePart' })
        if ($sum -gt 1.0001) { $bad += ("{0}: its children cover {1:N2} of it ({2})" -f $name, $sum, ($kids -join ' ')) }
    }
    $bad
}

# =============================================================================================
Section 'The textures'
# =============================================================================================

It 'every texture path the defs name resolves, case for case' {
    # Windows finds Teshi_East.png for a def asking for Teshi_east; Linux does not, and neither
    # does a case-sensitive archive. Test-Path would pass and the mod would ship broken, so each
    # segment is compared with -ceq against what the directory really holds.
    $texRoot = Join-Path $modDir 'Textures'
    $problems = @()
    foreach ($n in $kindNode.SelectNodes('.//texPath')) {
        $p = $n.InnerText.Trim()
        if ($p -like 'Things/Pawn/Animal/Dromedary/*') { continue }   # the game's own, see the header
        $segs = @($p -split '/')
        $dir = $texRoot
        $ok = $true
        for ($i = 0; $i -lt $segs.Count - 1; $i++) {
            $match = @(Get-ChildItem $dir -Directory | Where-Object { $_.Name -ceq $segs[$i] })
            if ($match.Count -ne 1) { $problems += "$p : the directory '$($segs[$i])' does not exist with that exact case"; $ok = $false; break }
            $dir = $match[0].FullName
        }
        if (-not $ok) { continue }
        $leaf = $segs[$segs.Count - 1]
        # Graphic_Multi asks for three facings; west is optional and mirrored from east.
        foreach ($suffix in @('_north', '_east', '_south')) {
            $want = "$leaf$suffix.png"
            $hit = @(Get-ChildItem $dir -File | Where-Object { $_.Name -ceq $want })
            if ($hit.Count -ne 1) { $problems += "$p : $want is missing, or differs in case" }
        }
    }
    $problems
}

It 'no texture is shipped that no def asks for' {
    $asked = @{}
    foreach ($n in $kindNode.SelectNodes('.//texPath')) {
        $leaf = @($n.InnerText.Trim() -split '/')[-1]
        foreach ($suffix in @('_north', '_east', '_south')) { $asked["$leaf$suffix.png"] = $true }
    }
    $orphans = @()
    foreach ($f in (Get-ChildItem (Join-Path $modDir 'Textures') -Recurse -File)) {
        if (-not $asked.ContainsKey($f.Name)) { $orphans += $f.Name }
    }
    if ($orphans.Count -gt 0) { "shipped, but named by no def: $($orphans -join ', ')" }
}

# =============================================================================================
Section 'What it leans on'
# =============================================================================================

It 'the vanilla bases these defs inherit from still exist' {
    foreach ($n in $defNodes) {
        $p = $n.GetAttribute('ParentName')
        if (-not $p) { continue }
        if (-not $vanillaAbstract.ContainsKey($p)) { "ParentName '$p' is declared by no def in the game: the def would not load at all." }
        elseif ($vanillaAbstract[$p] -cne $n.LocalName) { "ParentName '$p' is a $($vanillaAbstract[$p]), but it is used on a $($n.LocalName)." }
    }
}

It 'the body def name does not collide with one of the game own' {
    # Two defs of one name: the last loaded wins, silently. A body named after a vanilla one would
    # rewrite that animal's anatomy for every other mod in the list too.
    $bn = Get-Text $bodyNode 'defName'
    if (Has-Vanilla 'BodyDef' $bn) { "BodyDef '$bn' is also declared by the game: whichever loads last replaces the other, with no error." }
}

It 'every def this animal names by hand exists' {
    foreach ($pair in @(
        ,@('race/leatherDef',            'ThingDef')
        ,@('race/trainability',          'TrainabilityDef')
        ,@('race/soundMeleeHitPawn',     'SoundDef')
        ,@('race/soundMeleeHitBuilding', 'SoundDef')
        ,@('race/soundMeleeMiss',        'SoundDef')
    )) {
        $v = Get-Text $teshiNode $pair[0]
        if (-not $v) { continue }
        if (-not (Has-Vanilla $pair[1] $v)) { "$($pair[0]) names '$v', which is no $($pair[1]) in the game." }
    }
    $b = Get-Text $teshiNode 'race/body'
    if ($b -cne (Get-Text $bodyNode 'defName') -and -not (Has-Vanilla 'BodyDef' $b)) {
        "race/body names '$b', which is neither this mod's body def nor one of the game's."
    }
    foreach ($li in $teshiNode.SelectNodes('race/lifeStageAges/li')) {
        $d = Get-Text $li 'def'
        if ($d -and -not (Has-Vanilla 'LifeStageDef' $d)) { "lifeStageAges names '$d', which is no LifeStageDef." }
    }
    foreach ($li in $teshiNode.SelectNodes('tools/li/capacities/li')) {
        $v = $li.InnerText.Trim()
        if (-not (Has-Vanilla 'ToolCapacityDef' $v)) { "a tool names the capacity '$v', which is no ToolCapacityDef." }
    }
    $race = Get-Text $kindNode 'race'
    if ($race -cne (Get-Text $teshiNode 'defName')) { "the PawnKindDef names race '$race', which is not this mod's animal." }
}

It 'the biomes it spawns in are real biomes, and the weights are weights' {
    $bad = @()
    $n = 0
    foreach ($b in $teshiNode.SelectNodes('race/wildBiomes/*')) {
        if ($b.NodeType -ne 'Element') { continue }
        $n++
        if (-not (Has-Vanilla 'BiomeDef' $b.LocalName)) { $bad += "wildBiomes names '$($b.LocalName)', which is no BiomeDef"; continue }
        $v = [double]$b.InnerText.Trim()
        if ($v -le 0 -or $v -gt 1) { $bad += "wildBiomes/$($b.LocalName) is $v, outside the 0..1 the game reads as a commonality" }
    }
    if ($n -eq 0) { $bad += 'no wildBiomes at all: the animal would never appear on a map by itself' }
    $bad
}

It 'the food types it eats are flags the game defines' {
    $v = Get-Text $teshiNode 'race/foodType'
    if (-not $v) { return 'no foodType: the animal would eat nothing.' }
    $enum = $byName['FoodTypeFlags']
    if (-not $enum) { return 'FoodTypeFlags is gone from the game.' }
    $names = @([System.Enum]::GetNames($enum))
    foreach ($f in ($v -split ',')) {
        $t = $f.Trim()
        if ($names -notcontains $t) { "foodType names '$t', which is no value of FoodTypeFlags: $(Show-Some $names)" }
    }
}

# =============================================================================================
Write-Output ''
Write-Output "$($script:ran) tests, $($script:failed) failed"
[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)
if ($script:failed -gt 0) { exit 1 }
exit 0

<#
  SEEN TO FAIL
  ============

  Sixteen faults, each applied ALONE to a copy of Mod/ in a scratch directory, the suite run
  against the copy with -ModRoot, and each required to wake its own test. Fifteen woke exactly one
  test; the two exceptions are worth reading rather than hiding.

    wildness put back under <race>        -> the vanished-field test
    Wildness taken out of statBases       -> the stat test
    eggCountRange lowered to 1            -> the mated-laying test, naming 1 and 1
    eggProgressUnfertilizedMax set to 1.0 -> the lone-female test, and it says scenario 4b is
                                             then written the wrong way round
    hatcherPawn pointed at Muffalo        -> the hatching test
    pathfinderDangerous written           -> the inert-setting test, alone, naming that field.
                                             It is one of the fourteen public fields with no
                                             reader left in 1.6, so it is the cheapest way to
                                             prove the sweep bites.
    a tool pointed at LeftHand            -> the tool-group test: the group exists in the game,
                                             but this body puts it on no part, and nothing in the
                                             game says so at load
    a coverage raised to 0.95             -> the coverage test
    Teshi_east.png renamed Teshi_East.png -> the case test. Test-Path would have passed: this is
                                             the fault that is invisible on Windows and fatal on
                                             a case-sensitive filesystem. Renaming by case alone
                                             needs an intermediate name, Windows refuses it in one
                                             step.
    an extra Teshi_up.png shipped         -> the orphan test
    ParentName misspelt EggUnfertBasee    -> the bases test AND the harness guard, see below
    the body renamed QuadrupedAnimalWithHooves -> the collision test
    leatherDef misspelt                   -> the named-defs test
    a biome renamed AridShrublandd        -> the biome test
    a food flag changed to Plankton       -> the food-flag test
    the whole race def file deleted       -> thirteen tests, the harness guard first

  The two exceptions.

  Deleting the race def wakes thirteen tests, which is right: the animal, its comp and its
  textures are all gone, and the harness guard is there precisely so the run opens with "the
  animal was not found" instead of a wall of secondary failures.

  Misspelling a ParentName wakes the harness guard too, and that is a real coupling rather than a
  flaw to paper over. Two ThingDefs live in this mod, the animal and its two eggs, so they are
  told apart by the base they inherit from - there is no other stable discriminator, and taking
  them by defName would break the rule that a test about a name must not hold its def by that
  name. Misspell the base and the egg is no longer recognised. The run still names the real fault.

  NOT SEEN TO FAIL: "the egg-layer settings are read by the egg-layer comp, not by something
  else". It reads the game, not the mod, so no edit to this mod can turn it red - deleting the
  race def does make it fire, but only because the fields were never collected, which is a
  different failure wearing the same label. It would take a patched Assembly-CSharp to see it go
  red for its own reason, and that is not done here. It is kept because it is the test that would
  speak if a future RimWorld moved egg-laying to another class.
#>
