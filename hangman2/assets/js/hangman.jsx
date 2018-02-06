import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function game_init(root) {
  ReactDOM.render(<HangmanGame channel={channel} />, root);
}

// App state for Hangman is:
// {
//    word: String    // the word to be guessed
//    guesses: String // letters guessed so far
// }
//
// A TodoItem is:
//   { name: String, done: Bool }


class HangmanGame extends React.Component {
  constructor(props) {
    super(props);

    // My code
    this.channel = props.channel

    this.state = {
      //word: "elephant",
      //guesses: "",
      skel: "",
      goods: [],
      bads: [],
      max: 10
    };

    // My code
    this.channel.join()
                .receive("ok", this.gotView.bind(this))
                .receive("error", resp => {console.log("Unable to join", resp)});
  }

  // My code
  gotView(view) {
    console.log("New view", view);
    this.setState(view.game);
  }

  sendGuess(ev) {
    this.channel.push("guess", {letter: ev.key})
        .receive("ok", this.gotView.bind(this));
  }
  // code ends

  wordLetters() {
    return this.state.word.split("");
  }

  guessLetters() {
    return _.uniq(this.state.guesses.split(""));
  }

  badGuessLetters() {
    let goods = this.wordLetters();
    let bads = [];
    this.guessLetters().forEach( (gg) => {
      if (!goods.includes(gg)) {
        bads.push(gg);
      }
    });
    return bads;
  }

  setGuesses(ev) {
    let input = $(ev.target);
    let st1 = _.extend(this.state, {
      guesses: input.val(),
    });
    this.setState(st1);
  }

  render() {
    return (
      <div className="row">
        <div className="col-6">
          <Word state={this.state} />
        </div>
        <div className="col-6">
          <Lives state={this.state} />
        </div>
        <div className="col-6">
          <Guesses state={this.state} />
        </div>
        <div className="col-6">
          <GuessInput guess={this.sendGuess.bind(this)} />
        </div>
      </div>
    );
  }
}

function Word(params) {
  //let root = params.root;
  let root = params.state;
  /*
  let guesses = root.guessLetters();
  let letters = _.map(root.wordLetters(), (xx, ii) => {
    let text = guesses.includes(xx) ? xx : "_";
    return <span style={{padding: "1ex"}} key={ii}>{text}</span>;
  });
  */
  let letters = _.map(state.skel, (xx, ii) => {
    return <span style={{padding: "lex"}} key={ii}>{xx}</span>;
  });

  return (
    <div>
      <p><b>The Word</b></p>
      <p>{letters}</p>
    </div>
  );
}

function Lives(params) {
  let state = params.state;
  return <div>
    <p><b>Guesses Left:</b></p>
    <p>{state.max - state.bads.length}</p>
  </div>;
}

function Guesses(params) {
  let state = params.state;
  return <div>
    <p><b>Bad Guesses</b></p>
    <p>{state.bads.join(" ")}</p>
  </div>;
}

function GuessInput(params) {
  return <div>
    <p><b>Type Your Guesses</b></p>
    <p><input type="text" onChange={params.guess} /></p>
  </div>;
}
