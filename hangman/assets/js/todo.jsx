import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap'

export default function todo_init(root) {
  ReactDOM.render(<Todo />, root);
}

// App state for Todo is:
//   { items: [List of TodoItem] }

// A TodoItem is:
//   { name: String, done: Bool }

class Todo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      items: [],
    };
  }

  addItem(name) {
    let item = { name: name, done: false };
    let xs = this.state.items.slice();
    xs.push(item);
    this.setState({ items: xs });
  }

  addItemClick() {
    let input = $('#add-item-box');
    this.addItem(input.val());
    input.val('');
    console.log(this.state);
  }

  markItem(name) {
    let xs = _.map(this.state.items, (item) => {
      if (item.name == name) {
        return _.extend(item, {done: true});
      }
      else {
        return item;
      }
    });
    this.setState({ items: xs });
  }

  render() {
    let item_list = _.map(this.state.items, (item, ii) => {
      return <TodoItem item={item} markItem={this.markItem.bind(this)} key={ii} />;
    });
    return (
      <div>
        <h4>Tasks:</h4>
        <ul>
          {item_list}
        </ul>
        <h4>Add Item</h4>
        <AddForm add={this.addItemClick.bind(this)} />
      </div>
    );
  }
}

function TodoItem(props) {
  let item = props.item;
  if (item.done) {
    return <li>{item.name} (done)</li>;
  }
  else {
    return <li>{item.name} <Button onClick={() => props.markItem(item.name)}>mark</Button></li>;
  }
}

function AddForm(props) {
  function keyPress(ev) {
    if (ev.key == "Enter") {
      props.add(ev);
    }
  }
  return (
    <div>
      <input type="text" id="add-item-box" onKeyPress={keyPress}/>
      <Button onClick={props.add}>Add Item</Button>
    </div>
  );
}
