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

    // TODO remove 800px styling once background image styling has been fixed.
    return (
      <div className="grid-paper-background">
        <div className="wrapper-seventy">
          <div className="u-paddingTop5 small-link">
            <a href={`/users/${userId}`}>Back to My Report Templates</a>
          </div>

          <div className="simple-form" style={{"height": "800px"}}>
            <FlashMessage notice={notice} alert={alert} />

            <h2>New Report Template</h2>
            <form>
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
            </form>
          </div>
        </div>
      </div>
    );
  }
});
