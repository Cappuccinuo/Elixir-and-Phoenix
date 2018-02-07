'use strict'

import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

// Set the card type and match number
const uniqueCards = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

export default function run_demo(root) {
  ReactDOM.render(<Board/>, root);
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
  }

  initialState() {
    return {
      squares: this.shuffleDeck(),
      selected: [],
      pairs: [],
      steps: 0,
    };
  }

  restart() {
    this.setState(this.initialState());
  }

  shuffleDeck() {
    let deck = uniqueCards.slice();
    deck = deck.concat(deck);
    deck = _.shuffle(deck);
    return deck;
  }

  handleClick(i) {
    this.setState({steps: this.state.steps + 1})
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
      if (this.state.steps <= 50) {
        alert("Good Job!");
      }
      else if (this.state.steps >= 50 && this.state.steps < 100) {
        alert("Not Bad!");
      }
      else {
        alert("Come on!");
      }
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
    const score = "Score: ";
    const gameboard = this.gameBoard();

    return (
      <div>
        <div className="restart">
          <button onClick={this.restart}>Restart</button>
        </div>
        <div className="score">
          <span>Score: {200 - this.state.steps}</span>
        </div>
        <div className="game">
          {gameboard}
        </div>
      </div>
    );
  }
}
