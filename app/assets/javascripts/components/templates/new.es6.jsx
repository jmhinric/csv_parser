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

const TemplateNew = React.createClass({
  propTypes: {
    template: React.PropTypes.object.isRequired,
    userId: React.PropTypes.string,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  handleTextChange(e) {
    this.props.template.description = e.target.value;
  },

  handleSubmit(e) {
    e.preventDefault();
    $.post('/templates', { template: this.props.template })
  },

  render() {
    const { template, userId, notice, alert } = this.props;

    return (
      // TODO remove 800px styling once background image styling has been fixed.
      <div className="simple-form grid-paper-background" style={{"height": "800px"}}>
        <FlashMessage notice={notice} alert={alert} />

        <h2>New Report Template</h2>
        <form className="slim-form">
          <div className="field">
            <div>Name</div>
            <ModelInput model={template} attribute="name" />
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
            <a href={`/users/${userId}`}>Back to My Report Templates</a>
          </div>
        </form>
      </div>
    );
  }
});
