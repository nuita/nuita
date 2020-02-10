import glob from 'glob'
import path from 'path'

const packs = path.join(__dirname, 'app', 'javascript', 'packs');

const targets = glob.sync(path.join(packs, '**/*.{js,jsx,ts,tsx}'));

const entry = targets.reduce((entry, target) => {
  const bundle = path.relative(packs, target)
  const ext = path.extname(bundle);

  return Object.assign({}, entry, {
    // Input: "Application.js"
    // Output: {"application", "./application.js"}
    [bundle.replace(ext, '')]: './' + bundle,
  })
}, {});

module.exports = {
  context: packs
  entry,
  // inside.pixiv.blog/subal/4615
}
