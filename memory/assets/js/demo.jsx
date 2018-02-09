'use strict'

import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root, channel) {
  ReactDOM.render(<MemoryGame channel={channel}/>, root);
}

class Square extends React.Component {
  render() {
    const toggleVisible = this.props.isTurned ? 'visible' : this.props.isMatch ? 'visible' : 'hidden';
    const changeColor = this.props.isMatch ? '#C4C9CF' : 'white';
    let style = {
      visibility: toggleVisible,
    };
    let wholeStyle = {
      background: changeColor,
    }
    return (
      <button className="square" style={wholeStyle} onClick={this.props.onClick}>
        <div style={style}>
          <div>{this.props.value}</div>
        </div>
      </button>
    );
  }
}

class MemoryGame extends React.Component {
  constructor(props) {
    super(props)
    this.resetTime = null
    this.state = {
      turned: [],
      show: [],
      index: [],
      tests:[],
    }
    this.channel = props.channel;
    this.channel.join()
                .receive("ok", this.gotView.bind(this))
                .receive("error", resp => {console.log("Unable to join", resp)});
  }

  gotView(view) {
    console.log("New view", view);
    this.setState(view.game);
  }

  sendGuess(i) {
    if (!this.state.index.includes(i) && !this.state.show.includes(i)) {
      this.channel.push("test", {"card": i})
                  .receive("ok", this.gotView.bind(this));
      if (this.state.show.includes(i) || this.resetTime) {
        return;
      }
      if (this.state.show.length >= 1) {
        this.resetTime = setTimeout(() => {
          this.sendReset();
        }, 500);
      }
    }
  }

  sendReset() {
    this.channel.push("reset", {"clear": true})
                .receive("ok", this.gotView.bind(this));
    this.resetTime = null;
  }

  render() {
    return (
    <div>
      <div className="game">
        {this.state.tests.map((card, i) => {
          return <Square
            value={card}
            onClick={() => this.sendGuess(i)}
            isTurned={this.state.show.includes(i)}
            isMatch={this.state.index.includes(i)}
            key={i}/>;
        }, this)}
      </div>
      <div>
        <ButtonValue state={this.state} />
        <TestValue state={this.state} />
      </div>
    </div>
    );
  }
}

function TestValue(params) {
  let state = params.state;
  return <div>
    <p>Show Value: {state.show}</p>
    <p>Turned Value2: {state.turned}</p>
    <p>Turned Indices: {state.index}</p>
    <p>Cards:{state.tests}</p>
  </div>
}

function ButtonValue(params) {
  let state = params.state;
  return <div>
    <p>Button Value: {state.turned.length}</p>
  </div>
}
