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

  handleDelete() {
    const { template, originFile } = this.props;
    if (confirm("Are you sure you want to delete this origin file and all of its data transfers?") == true) {
      $.ajax({
        type: 'DELETE',
        url: `/templates/${template.id}/origin_files/${originFile.id}`
      });
    }
  },

  render() {
    const { template, originFile, notice, alert } = this.props;

    // TODO remove 800px styling once background image styling has been fixed.
    return (
      <div className="grid-paper-background">
        <FlashMessage notice={notice} alert={alert} />
        <div className="wrapper-seventy">
          <div className="u-paddingTop5">
            <a href={`/templates/${template.id}`} className="small-link">Back</a>
          </div>

          <div className="simple-form u-paddingTop10 u-paddingBottom8" style={{"height": "800px"}}>
            <h2>{`Template: ${template.name}`}</h2>
            <div className="centered" style={{ "fontSize": "1.3em", "fontWeight": "bold" }}>
              {`${originFile.id ? '' : 'New '}Origin File:`}
            </div>
            <form>
              <div className="field">
                <div>Name</div>
                <ModelInput key="new-edit" model={originFile} attribute="name" />
                { originFile.id &&
                  <div onClick={this.handleDelete} className="small-link u-marginTop0pt5">Delete</div>
                }
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
