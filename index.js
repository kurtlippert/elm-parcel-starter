// import { Elm } from 'src/Main.elm'
import { Elm } from 'src/Uitest.elm'
import "bootstrap-utilities"

if (module.hot) {
  module.hot.accept()
}

// const app = Elm.Main.init({
const app = Elm.Uitest.init({
  node: document.getElementById('app')
})

app.ports.printModel.subscribe(model => console.log(model))
