const { PropTypes } = React;

const DataTransferNew = React.createClass({

  propTypes: {
    template: PropTypes.object.isRequired,
    originFile: PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      type: 'single',
      dataTransfer: {}
    };
  },

  handleSelectChange(obj) {
    this.setState(obj);
  },

  handleSubmit(e) {
    const { template, originFile } = this.props;
    e.preventDefault();
    const { dataTransfer, type } = this.state;
    dataTransfer.type = type;

    $.post(
      `/templates/${template.id}/origin_files/${originFile.id}/data_transfers`,
      { data_transfer: dataTransfer }
    )
  },

  render() {
    const { template, originFile } = this.props;
    const { type, dataTransfer } = this.state;

    return (
      <div className="wrapper-seventy">
        <div className="simple-form u-paddingTopBottom3">
          <h4 className="u-paddingBottom3">{`New ${originFile.name} Data Transfer`}</h4>
          <form>
            <div className="u-paddingBottom3 u-size1of2 margin-zero-auto">
              <SelectTransferType
                onSelectChange={this.handleSelectChange}
                attr={"type"}
                value={type}
              />
            </div>

            <div className="Grid">
              <div className="Grid-cell u-size1of2">
                <h3>Origin:</h3>
                <div className="field">
                  <div>Worksheet</div>
                  <ModelInput model={dataTransfer} attribute="origin_worksheet_index" required />
                </div>
                <div className="field">
                  <div>Begin Cell</div>
                  <ModelInput model={dataTransfer} attribute="origin_begin_value" required />
                </div>
                { type != "single" &&
                  <div className="field">
                    <div>End Cell</div>
                    <ModelInput model={dataTransfer} attribute="origin_end_value" required />
                  </div>
                }
              </div>

              <div className="Grid-cell u-size1of2">
                <h3>Destination:</h3>
                <div className="field">
                  <div>Worksheet</div>
                  <ModelInput model={dataTransfer} attribute="destination_worksheet_index" required />
                </div>
                <div className="field">
                  <div>Begin Cell</div>
                  <ModelInput model={dataTransfer} attribute="destination_begin_value" required />
                </div>
                { type != "single" &&
                  <div className="field">
                    <div>End Cell</div>
                    <ModelInput model={dataTransfer} attribute="destination_end_value" required />
                  </div>
                }
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
    );
  }
});
