const OriginFileForm = React.createClass({
  propTypes: {
    template: React.PropTypes.object.isRequired,
    originFile: React.PropTypes.object.isRequired,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  handleSubmit(e) {
    e.preventDefault();
    const { template, originFile } = this.props;
    const baseRoute = `/templates/${template.id}/origin_files`;

    if (originFile.id) {
      $.ajax({
        type: "PATCH",
        url: `${baseRoute}/${originFile.id}`,
        data: { origin_file: originFile }
      })
    }
    else {
      $.post(baseRoute, { origin_file: originFile });
    }
  },

  render() {
    const { template, originFile, notice, alert } = this.props;

    // TODO remove 800px styling once background image styling has been fixed.
    return (
      <div className="grid-paper-background">
        <div className="wrapper-seventy">
          <div className="u-paddingTop5 small-link">
            <a href={`/templates/${template.id}`}>Back</a>
          </div>

          <div className="simple-form u-paddingTop10 u-paddingBottom8" style={{"height": "800px"}}>
            <FlashMessage notice={notice} alert={alert} />

            <h2>{`New Origin File for ${template.name}`}</h2>
            <form>
              <div className="field">
                <div>Name</div>
                <ModelInput model={originFile} attribute="name" />
              </div>

              <input
                type="submit"
                onClick={this.handleSubmit}
                className="submit-button button"
                value={`${originFile.id ? 'Save' : 'Create'}`}
              />
            </form>
          </div>
        </div>
      </div>
    );
  }
});
