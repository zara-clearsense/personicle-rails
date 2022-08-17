const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')


const alias =  require('./alias/alias')

const webpack = require("webpack")
environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  }))

environment.config.merge(alias)
environment.loaders.prepend('coffee', coffee)
module.exports = environment
