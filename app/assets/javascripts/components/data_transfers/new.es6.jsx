const { PropTypes } = React;

const TransferType = () => (
  <div className="field">
    <select style={{"margin":"0 auto"}}>
      <option value="single">Single</option>
      <option value="column">Column</option>
      <option value="row">Row</option>
    </select>
  </div>
);

const DataTransferNew = React.createClass({
  propTypes: {
    template: PropTypes.object.isRequired,
    originFile: PropTypes.object.isRequired,
    notice: PropTypes.string,
    alert: PropTypes.string
  },

  getInitialState() {
    return {
      dataTransfer: {}
    };
  },

  handleSubmit(e) {
    const { template, originFile } = this.props;
    e.preventDefault();
    $.post(
      `/templates/${template.id}/origin_files/${originFile.id}/data_transfers`,
      { data_transfers: this.state.dataTransfer })
  },

  render() {
    const { template, originFile, notice, alert } = this.props;

    // TODO remove 800px styling once background image styling has been fixed.
    return (
      <div className="grid-paper-background">
        <div className="wrapper-seventy">
          <div className="small-link u-paddingTop5">
            <a href={`/templates/${template.id}/data_transfers`}>Back to data transfer details</a>
          </div>

          <div className="simple-form" style={{"height": "800px"}}>
            <FlashMessage notice={notice} alert={alert} />

            <h2 className="u-paddingBottom3">New Data Transfer</h2>
            <form>
              <div className="Grid">
                <div className="Grid-cell u-size1of2">
                  <h3>Origin:</h3>
                  <TransferType />

                </div>
                <div className="Grid-cell u-size1of2">
                  <h3>Destination:</h3>
                  <TransferType />

                </div>
                <input
                  type="submit"
                  onClick={this.handleSubmit}
                  className="submit-button button u-marginTop9"
                  value="Submit"
                />
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
});
