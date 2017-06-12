const TemplateForm = React.createClass({
  propTypes: {
    template: React.PropTypes.object.isRequired,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
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

  handleDelete() {
    const { template } = this.props;
    if (confirm("Are you sure you want to delete this template and all of its origin files and data transfers?") == true) {
      $.ajax({
        type: 'DELETE',
        url: `/templates/${template.id}`
      });
    }
  },

  render() {
    const { template, notice, alert } = this.props;

    return (
      <div>
        <FlashMessage notice={notice} alert={alert} />
        <div className="wrapper-seventy">
          <div className="u-paddingTop5">
            <a href={`/templates`} className="small-link">Back to My Report Templates</a>
          </div>

          <div className="simple-form u-paddingTop10 u-paddingBottom8" style={{"height": "800px"}}>
            <h2>{`${template.id ? '' : 'New '}Report Template:`}</h2>
            <form>
              <div className="field">
                <div>Name</div>
                <ModelInput model={template} attribute="name" />
              </div>
              <div className="field">
                <div>Description</div>
                <textarea value={this.state.description} onChange={this.handleTextChange}></textarea>
                { template.id &&
                  <div onClick={this.handleDelete} className="small-link u-marginTop0pt5">
                    Delete this template
                  </div>
                }
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
