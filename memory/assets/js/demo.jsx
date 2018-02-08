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

class Board extends React.Component {
  constructor(props) {
    super(props);
    this.restart = this.restart.bind(this);
    this.resetTime = null;
    this.state = this.initialState();
    this.channel = props.channel;
    this.channel.join()
                .receive("ok", this.gotView.bind(this))
                .receive("error", resp => {console.log("Unable to join", resp)});
  }

  initialState() {
    return {
      pairs: [],
    };
  }

  gotView(view) {
    console.log("New view", view);
    this.setState(view.game)
  }

  sendSelection(ev) {
    this.channel.push("guess", {card: ev.key})
                .receive("ok", this.gotView.bind(this))
  }

  restart() {
    this.setState(this.initialState());
  }

  handleClick(i) {
    if (this.state.selected.includes(i) || this.resetTime) {
      return;
    }
    if (this.state.selected.length >= 1) {
      this.resetTime = setTimeout(() => {
        this.checkMatch();
      }, 500);
    }

    let deck = this.state.squares;
    const selected = this.state.selected.slice();
    const squares = this.state.squares.slice();
    squares[i] = deck[i];
    this.state.selected.push(i);
    this.setState({selected: this.state.selected});
    this.setState({squares: squares});
  }

  checkMatch() {
    let pairs = this.state.pairs;
    const matchSelected = this.state.selected.map((i) => {
      return this.state.squares[i];
    });

    if (matchSelected[0] == matchSelected[1]) {
      pairs = pairs.concat(this.state.selected);
    }

    this.setState({selected: [], pairs: pairs});
    this.resetTime = null;

    if (this.state.pairs.length === this.state.squares.length) {
    }
  }

  renderSquare(i) {
    return <Square
      value={this.state.squares[i]}
      onClick={() => this.handleClick(i)}/>;
  }

  gameBoard() {
    return (
      <div id="gameBoard">
        {this.state.squares.map((card, i) => {
          return <Square
            value={this.state.squares[i]}
            onClick={() => this.handleClick(i)}
            isTurned={this.state.selected.includes(i)}
            isMatch={this.state.pairs.includes(i)}
            key={i}/>;
        }, this)}
      </div>
    )
  }

  render() {
    const gameboard = this.gameBoard();

    return (
      <div>
        <div className="restart">
          <button onClick={this.restart}>Restart</button>
        </div>
        <div className="game">
          {gameboard}
        </div>
      </div>
    );
  }
}

class MemoryGame extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      turned: [],
      cards: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
      show: [],
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
    this.channel.push("test", {"card": i})
                .receive("ok", this.gotView.bind(this));
  }

  render() {
    return (
    <div>
      <div>
        {this.state.cards.map((card, i) => {
          return <Button
            value= {i}
            onClick={() => this.sendGuess(i)}
            key={i}>Number: {i}</Button>;
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
    <p>Test Value: {state.show}</p>
    <p>Test Value2: {state.turned}</p>
  </div>
}

function ButtonValue(params) {
  let state = params.state;
  return <div>
    <p>Button Value: {state.turned.length}</p>
  </div>
}
