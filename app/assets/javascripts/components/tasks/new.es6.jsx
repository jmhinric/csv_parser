const NewDataTransfer = () => (
  <div>
    <div className="field">
      <select>
        <option value="single">Single</option>
        <option value="column">Column</option>
        <option value="row">Row</option>
      </select>
    </div>
  </div>
);

const TaskNew = React.createClass({
  propTypes: {
    task: React.PropTypes.object.isRequired,
    userId: React.PropTypes.string,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  handleTextChange(e) {
    this.props.task.description = e.target.value;
  },

  handleSubmit(e) {
    e.preventDefault();
    $.post('/tasks', { task: this.props.task })
  },

  render() {
    const { task, userId, notice, alert } = this.props;

    return (
      // TODO remove 800px styling once background image styling has been fixed.
      <div className="simple-form grid-paper-background" style={{"height": "800px"}}>
        <FlashMessage notice={notice} alert={alert} />

        <h2>New Report Task</h2>
        <form className="slim-form">
          <div className="field">
            <div>Name</div>
            <ModelInput model={task} attribute="name" />
          </div>
          <div className="field">
            <div>Description</div>
            <textarea onChange={this.handleTextChange}></textarea>
          </div>


          <input
            type="submit"
            onClick={this.handleSubmit}
            className="submit-button button"
            value="Submit"
          />

          <div className="small-link">
            <a href={`/users/${userId}`}>Back to My Report Tasks</a>
          </div>
        </form>
      </div>
    );
  }
});
