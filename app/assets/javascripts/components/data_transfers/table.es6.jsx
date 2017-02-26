const { PropTypes } = React;

const DataTransferTable = React.createClass({

  propTypes: {
    template: PropTypes.object.isRequired,
    originFile: React.PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      showAddTransfer: false
    }
  },

  handleAddRemoveDataTransfer() {
    this.setState({ showAddTransfer: !this.state.showAddTransfer });
  },

  render() {
    const { template, originFile } = this.props;
    const { showAddTransfer } = this.state;

    return (
      <div key={originFile.id} className="u-paddingTop3 u-paddingBottom5">
        <div className="transfer-groups-container">
          <div className="u-paddingBottom3">
            <table>
              <tbody>
                <tr>
                  <th className="lightest-gray-background" colSpan={3}>
                    {originFile.name}
                  </th>
                  <th className="lightest-gray-background" colSpan={3}>
                    {template.name}
                  </th>
                </tr>
                <tr>
                  <th>Worksheet</th>
                  <th>Begin Cell</th>
                  <th>End Cell</th>
                  <th>Worksheet</th>
                  <th>Begin Cell</th>
                  <th>End Cell</th>
                </tr>
                {
                  originFile.dataTransfers.map((dataTransfer, index) => {
                    return (
                      <tr className={`table-row-${index % 2 == 0 ? 'even' : 'odd'}`}>
                      <td>{dataTransfer.originCellRange.worksheetIndex}</td>
                      <td>{dataTransfer.originCellRange.beginValue}</td>
                      <td>{dataTransfer.originCellRange.endValue || '-'}</td>
                      <td>{dataTransfer.destinationCellRange.worksheetIndex}</td>
                      <td>{dataTransfer.destinationCellRange.beginValue}</td>
                      <td>{dataTransfer.destinationCellRange.endValue || '-'}</td>
                      </tr>
                    )
                  })
                }
              </tbody>
            </table>
          </div>
        </div>

        <div className="u-paddingBottom1 u-posCenter">
          <a className="small-link" onClick={this.handleAddRemoveDataTransfer}>
            {`${showAddTransfer ? 'Hide' : 'Add data transfer'}`}
          </a>

          <React.addons.CSSTransitionGroup
            transitionName="fade"
            transitionEnterTimeout={300}
            transitionLeaveTimeout={250}
          >
            { showAddTransfer && <DataTransferNew template={template} originFile={originFile} />}
          </React.addons.CSSTransitionGroup>
        </div>
      </div>
    );
  }
});
