const TemplateForm = React.createClass({
  propTypes: {
    template: React.PropTypes.object.isRequired,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  componentWillMount() {
    let { template, template: { name, description } } = this.props;
    template.name = name || '';
    template.description = description || '';
  },

  getInitialState() {
    return { description: this.props.template.description || '' };
  },

  handleTextChange(e) {
    this.props.template.description = e.target.value;
    this.setState({ description: e.target.value });
  },

  handleSubmit(e) {
    e.preventDefault();
    const { template } = this.props;
    const baseRoute = '/templates';

    if (template.id) {
      $.ajax({
        type: "PATCH",
        url: `${baseRoute}/${template.id}`,
        data: { template: template }
      })
    }
    else {
      $.post(baseRoute, { template: template });
    }
  },

  render() {
    const { template, notice, alert } = this.props;

    // TODO remove 800px styling once background image styling has been fixed.
    return (
      <div className="grid-paper-background">
        <div className="wrapper-seventy">
          <div className="u-paddingTop5">
            <a href={`/templates`} className="small-link">Back to My Report Templates</a>
          </div>

          <div className="simple-form u-paddingTop10 u-paddingBottom8" style={{"height": "800px"}}>
            <FlashMessage notice={notice} alert={alert} />

            <h2>{`${template.id ? '' : 'New '}Report Template:`}</h2>
            <form>
              <div className="field">
                <div>Name</div>
                <ModelInput model={template} attribute="name" />
              </div>
              <div className="field">
                <div>Description</div>
                <textarea value={this.state.description} onChange={this.handleTextChange}></textarea>
              </div>

              <input
                type="submit"
                onClick={this.handleSubmit}
                className="submit-button button"
                value={`${template.id ? 'Save' : 'Create'}`}
              />
            </form>
          </div>
        </div>
      </div>
    );
  }
});
