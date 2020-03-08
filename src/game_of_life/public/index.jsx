import game_of_life from 'ic:canisters/game_of_life';
import * as React from 'react';
import { render } from 'react-dom';

class MyHello extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: 'Name',
      message: '',
    };
  }

  async doGreet() {
    const greeting = await custom_greeting.greet(this.state.name);
    this.setState({ ...this.state, message: greeting });
  }

  onNameChange(ev) {
    this.setState({ ...this.state, name: ev.target.value });
  }

  componentDidMount() {
    const canvas = this.refs.canvas
    const ctx = canvas.getContext("2d")
    ctx.fillStyle = "#FF0000"
    ctx.fillRect(0, 0, 80, 80)
  }

  render() {
    return (
      // <body style={
      //   { "position": "absolute" },
      //   { "top": "0" },
      //   { "left": "0" },
      //   { "width": "100 %" },
      //   { "height": "100 %" },
      //   { "display": "flex" },
      //   { "flex-direction": "column" },
      //   { "align-items": "center" },
      //   { "justify-content": "center" }}>
      //   <canvas id="game-of-life-canvas"></canvas>
      //   <div style={{ "font-size": "30px" }}>
      //     <div style={{ "background-color": "yellow" }}>
      //       <p>Greetings, from DFINITY!</p>
      //       <p> Type your message in the Name input field, then click <b> Get Greeting</b> to display the result.</p>
      //     </div>
      //     <div style={{ "margin": "30px" }}>
      //       <input id="name" value={this.state.name} onChange={ev => this.onNameChange(ev)}></input>
      //       <button onClick={() => this.doGreet()}>Get Greeting!</button>
      //     </div>
      //     <div>Greeting is: "<span style={{ "color": "blue" }}>{this.state.message}</span>"</div>
      //   </div>
      // </body>
      <div>
        <canvas ref="canvas" width={640} height={425} />
      </div>
    );
  }
}

render(<MyHello />, document.getElementById('app'));
