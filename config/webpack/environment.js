const { environment } = require('@rails/webpacker');

const WebpackerPwa = require('webpacker-pwa');
new WebpackerPwa(config, environment);

const typescript = require('./loaders/typescript');
environment.loaders.prepend('typescript', typescript);

module.exports = environment;
