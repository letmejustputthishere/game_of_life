import game_of_life from 'ic:canisters/game_of_life'
import * as React from 'react'
import { render } from 'react-dom'

class MyHello extends React.Component {
  constructor(props) {
    super(props)
    this.stopped = false
    this.state = {
    }
  }

  async doPopulate() {
    let width = document.getElementById("newEntryWidth").value;
    let height = document.getElementById("newEntryHeight").value;

    game_of_life.populate(parseInt(width, 10), parseInt(height, 10));
  }

  async getUniverse() {
    document.getElementById("newEntryWidth").value = parseInt(await game_of_life.get_width(), 10);
    document.getElementById("newEntryHeight").value = parseInt(await game_of_life.get_height(), 10);
  }

  async doStart() {
    game_of_life.start();
  }

  async doRender() {
    const pre = document.getElementById("game-of-life-canvas");
    const renderLoop = async () => {
      pre.textContent = await game_of_life.render();
      let old_universe = await game_of_life.get_universe();
      let temp = await game_of_life.tick();
      this.reqId = requestAnimationFrame(renderLoop);
      if (JSON.stringify(old_universe) == JSON.stringify(temp) || this.stopped == true) {
        console.log("match");
        cancelAnimationFrame(this.reqId);
      }
    };
    requestAnimationFrame(renderLoop);
    this.stopped = false;
  }

  async stopRender() {
    console.log(this.reqId);
    console.log(this.stopped);
    this.stopped = true;
    console.log("stopRender: " + this.stopped);
  }

  async renderCurrent() {
    const pre = document.getElementById("game-of-life-canvas");
    pre.textContent = await game_of_life.render();
  }

  render() {
    return (
      <body>
        <div>
          <h1>Game of Life</h1>
          <div>
            Populate the universe:
          <table>
              <tr><td>Width:</td><td><input id="newEntryWidth"></input></td></tr>
              <tr><td>Height:</td><td><input id="newEntryHeight"></input></td></tr>
            </table>
            <button onClick={() => this.doPopulate()}>Populate</button>
            <button onClick={() => this.getUniverse()}>Get Universe</button>
          </div>
          <div>
            Start the game:<button onClick={
              () => this.doStart()
            }>Start</button>
          </div>
        </div>
        <div >
          <pre id="game-of-life-canvas"></pre>
        </div>
        <div>
          Draw Matrix:<button onClick={
            () => this.doRender()
          }>Render</button>
          <button onClick={
            () => this.stopRender()
          }>Stop Render</button>
          <button onClick={
            () => this.renderCurrent()
          }>Render Current</button>
        </div>
      </body>
    );
  }
}

render(<MyHello />, document.getElementById('app'));
