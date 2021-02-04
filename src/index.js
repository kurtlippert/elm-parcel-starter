import { Elm } from './Main.elm'
import "bootstrap-utilities"

if (module.hot) {
  module.hot.accept()
}

const app = Elm.Main.init({
  node: document.getElementById('root')
})

app.ports.printModel.subscribe(model => console.log(model))
