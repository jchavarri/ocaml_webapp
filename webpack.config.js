const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const outputDir = path.join(__dirname, "server", "static");

const isProd = process.env.NODE_ENV === "production";

module.exports = {
  entry: "./client/src/Index.bs.js",
  mode: isProd ? "production" : "development",
  devtool: "source-map",
  output: {
    path: outputDir,
    filename: "Index.js",
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "client/src/index.html",
      inject: false,
    }),
  ],
  devServer: {
    compress: true,
    contentBase: outputDir,
    port: process.env.PORT || 8000,
    historyApiFallback: true,
    proxy: {
      "/api/": {
        target: "http://localhost:3000",
      },
    },
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
    ],
  },
};
