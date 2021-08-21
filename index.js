import { Elm } from './src/Main.elm'
// import { Elm } from './src/Uitest.elm'

if (module.hot) {
  module.hot.accept()
}

console.log(window.innerWidth)

const app = Elm.Main.init({
  node: document.getElementById('app'),
  flags: {
    windowWidth: window.innerWidth
  }
})

app.ports.printModel.subscribe(model => console.log(model))
