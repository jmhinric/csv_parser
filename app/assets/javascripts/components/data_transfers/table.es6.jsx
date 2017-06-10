const { PropTypes } = React;

const DisplayRow = ({ dataTransfer, classNames }) => {
  const baseClassNames = "Grid-cell u-size1of8 u-paddingTopBottom1 u-paddingLeft2";
  const classes = `${baseClassNames} ${classNames}`;
  return (
    <div key={`${dataTransfer.id}`} className="Grid">
      <div className="Grid-cell u-size1of8"></div>
      <div className={`${classes} borderLeft`}>
        {dataTransfer.originCellRange.worksheetIndex}
      </div>
      <div className={classes}>
        {dataTransfer.originCellRange.beginValue}
      </div>
      <div className={`${classes} borderRight`}>
        {dataTransfer.originCellRange.endValue || '-'}
      </div>
      <div className={classes}>
        {dataTransfer.destinationCellRange.worksheetIndex}
      </div>
      <div className={classes}>
        {dataTransfer.destinationCellRange.beginValue}
      </div>
      <div className={`${classes} borderRight`}>
        {dataTransfer.destinationCellRange.endValue || '-'}
      </div>
      <div className="Grid-cell u-size1of8"></div>
    </div>
  );
};

const DataTransferTable = React.createClass({
  propTypes: {
    template: PropTypes.object.isRequired,
    originFile: React.PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      newTransfer: {
        originCellRange: {},
        destinationCellRange: {},
        type: 'range'
      },
      addingTransfer: false
    }
  },

  handleAddRemoveDataTransfer() {
    this.setState({ addingTransfer: !this.state.addingTransfer });
  },

  // TODO: refactor component composition to avoid hack of constructing the border
  render() {
    const { template, originFile } = this.props;
    const { addingTransfer, editingDataTransferId, newTransfer } = this.state;
    let transfers = originFile.dataTransfers;
    const headerClassNames = "Grid-cell u-size1of8 light-gray-background" +
      " u-paddingTopBottom1 u-paddingLeft2";

    return (
      <div className="u-paddingTop3 u-paddingBottom5">
        <div className="transfer-groups-container">
          <div className="Grid margin-zero-auto" style={{ "fontSize": "1.1em" }}>
            <div className="Grid-cell u-size1of8"></div>
            <div
              className="Grid-cell u-paddingTopBottom1 u-size3of8 borderTop borderLeft borderRight lightest-gray-background"
              style={{ "textAlign": "center" }}
            >
              {`Origin: ${originFile.name}`}
            </div>
            <div
              className="Grid-cell u-paddingTopBottom1 u-size3of8 borderTop borderRight lightest-gray-background"
              style={{ "textAlign": "center" }}
            >
              {`Destination: ${template.name}`}
            </div>
            <div className="Grid-cell u-size1of8"></div>
          </div>

          <div className="Grid" style={{ "fontSize": "0.8em", "textAlign": "left" }}>
            <div className="Grid-cell u-size1of8"></div>
            <div className={`${headerClassNames} borderLeft`}>Worksheet</div>
            <div className={`${headerClassNames}`}>Begin Cell</div>
            <div className={`${headerClassNames} borderRight`}>End Cell</div>
            <div className={`${headerClassNames}`}>Worksheet</div>
            <div className={`${headerClassNames}`}>Begin Cell</div>
            <div className={`${headerClassNames} borderRight`}>End Cell</div>
            <div className="Grid-cell u-size1of8"></div>
          </div>

          {
            transfers.map((dataTransfer, index) => {
              let classNames = index % 2 != 0 ? 'lighter-gray-background' : '';
              if (!addingTransfer) classNames += ' borderBottom';
              return (
                <DisplayRow
                  key={`${dataTransfer.id}`}
                  dataTransfer={dataTransfer}
                  classNames={classNames}
                />
              );
            })
          }
          <React.addons.CSSTransitionGroup
            key="transition-new"
            transitionName="fade"
            transitionEnterTimeout={300}
            transitionLeaveTimeout={300}
          >
            { addingTransfer &&
              <DataTransferCreateEditRow
                key="new"
                dataTransfer={newTransfer}
                classNames={`borderBottom ${transfers.length % 2 !== 0 && 'lighter-gray-background'}`}
                saveRoute={`/templates/${template.id}/origin_files/${originFile.id}/data_transfers`}
              />
            }
          </React.addons.CSSTransitionGroup>
        </div>

        <div className="u-paddingBottom1 u-posCenter">
          <a className="small-link" onClick={this.handleAddRemoveDataTransfer}>
            {`${addingTransfer ? 'Hide' : 'Add data transfer'}`}
          </a>
        </div>
      </div>
    );
  }
});
