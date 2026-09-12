// Static HTML/CSS asset renderer. NODE_PATH may point to bundled dependencies.
// Usage: node Art/render-preview.cjs
const fs = require('node:fs/promises');
const path = require('node:path');
const http = require('node:http');
const { chromium } = require('playwright');
const sharp = require('sharp');
const root = __dirname;
const repo = path.dirname(root);
const readJSON = async name => JSON.parse(await fs.readFile(path.join(root,name),'utf8'));
const luminance = rgb => rgb.map(v=>v/255).map(v=>v<=.04045?v/12.92:((v+.055)/1.055)**2.4).reduce((a,v,i)=>a+v*[.2126,.7152,.0722][i],0);
const rgb = hex => hex.match(/[a-f0-9]{2}/gi).map(v=>parseInt(v,16));
const contrast = (a,b) => (Math.max(a,b)+.05)/(Math.min(a,b)+.05);
(async()=>{
  const palette = await readJSON('preview-palette.json');
  const layout = await readJSON('preview-layout.json');
  const about = await fs.readFile(path.join(repo,'Mod/About/About.xml'),'utf8');
  const versions = [...about.match(/<supportedVersions>([\s\S]*?)<\/supportedVersions>/)[1].matchAll(/<li>(\d+\.\d+)<\/li>/g)].map(m=>m[1]);
  versions.sort((a,b)=>{const x=a.split('.').map(Number),y=b.split('.').map(Number);return y[0]-x[0]||y[1]-x[1]});
  if(layout.version!==versions[0]) throw Error('Update layout.version to the highest declared stable version: '+versions[0]);
  const server = http.createServer(async(req,res)=>{
    const name = decodeURIComponent(new URL(req.url,'http://localhost').pathname).slice(1);
    if(!name || path.basename(name)!==name) {res.writeHead(404);return res.end();}
    try {
      const data = await fs.readFile(path.join(root,name));
      res.setHeader('Content-Type',name.endsWith('.html')?'text/html':name.endsWith('.json')?'application/json':'image/png');
      res.end(data);
    } catch {res.writeHead(404);res.end();}
  });
  await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
  let browser;
  try {
    browser = await chromium.launch({channel:'chrome',headless:true});
    const page = await browser.newPage({viewport:{width:layout.width,height:layout.height},deviceScaleFactor:1});
    await page.goto(`http://127.0.0.1:${server.address().port}/preview-composition.html`);
    await page.evaluate(()=>window.previewReady);
    const cdp = await page.context().newCDPSession(page);
    await cdp.send('DOM.enable'); await cdp.send('CSS.enable');
    const {root:dom} = await cdp.send('DOM.getDocument');
    const fonts={};
    for(const selector of ['h1 .primary','h1 .suffix','p','.version']) {
      const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:dom.nodeId,selector});
      fonts[selector]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;
    }
    if(Object.values(fonts).some(list=>!list.length||list.some(f=>!/^SegoeUI(?:-Semibold|-Bold)?$/.test(f.postScriptName)))) throw Error('Unexpected rendered font: '+JSON.stringify(fonts));
    const regions = await page.evaluate(()=>[...document.querySelectorAll('h1 span,p')].map(el=>{
      const r=el.getBoundingClientRect();return {text:el.textContent,x:r.x,y:r.y,width:r.width,height:r.height,color:getComputedStyle(el).color};
    }));
    if(regions.some(r=>r.x<0||r.y<0||r.x+r.width>816-24||r.y+r.height>504)) throw Error('Text outside safe bounds');
    const title = await page.locator('h1').innerText();
    const expected=about.match(/<name>(.*?)<\/name>/)[1];
    if(title.replace(/\s+/g,' ').trim()!==expected) throw Error('Title differs from About.xml');
    const final = await page.screenshot();
    await page.addStyleTag({content:'.text{display:none}.version{visibility:hidden}'});
    const background=await page.screenshot();
    const {data,info}=await sharp(background).removeAlpha().raw().toBuffer({resolveWithObject:true});
    const results=regions.map(r=>{
      const ink=luminance(r.color.match(/\d+/g).slice(0,3).map(Number));
      let worst=Infinity,point;
      for(let y=Math.max(0,Math.floor(r.y));y<Math.min(info.height,Math.ceil(r.y+r.height));y++) {
        for(let x=Math.max(0,Math.floor(r.x));x<Math.min(info.width,Math.ceil(r.x+r.width));x++) {
          const i=(y*info.width+x)*info.channels;
          const value=contrast(ink,luminance([...data.subarray(i,i+3)]));
          if(value<worst){worst=value;point=[x,y];}
        }
      }
      return {...r,worstContrast:Math.round(worst*100)/100,worstPoint:point};
    });
    const badgeContrast=contrast(luminance(rgb(palette.badgeInk)),luminance(rgb(palette.accent)));
    const report={date:'2026-09-12',dimensions:[info.width,info.height],version:layout.version,fonts,regions:results,badgeContrast:Math.round(badgeContrast*100)/100,method:'All background pixels within each text bounding rectangle, text hidden; conservative minimum. Badge uses its opaque fill.'};
    await fs.writeFile(path.join(root,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
    if(results.some(r=>r.worstContrast<4.5)||badgeContrast<4.5) throw Error('Contrast failed: '+JSON.stringify(report));
    const png=await sharp(final).png({compressionLevel:9}).toBuffer();
    if(png.length>=900000) throw Error('Preview exceeds 900 kB');
    await fs.writeFile(path.join(repo,'Mod/About/Preview.png'),png);
    await sharp(png).resize({width:268}).png().toFile(path.join(root,'preview-268.png'));
    await fs.writeFile(path.join(root,'preview-background-qa.png'),background);
    console.log(JSON.stringify({bytes:png.length,fonts,contrast:results.map(r=>({text:r.text,min:r.worstContrast})),badgeContrast:report.badgeContrast},null,2));
  } finally {if(browser) await browser.close();await new Promise(resolve=>server.close(resolve));}
})().catch(e=>{console.error(e);process.exitCode=1;});
