const { PropTypes } = React;

const DataTransferCreateEditRow = React.createClass({
  propTypes: {
    dataTransfer: PropTypes.object.isRequired,
    classNames: PropTypes.string.isRequired,
    saveRoute: PropTypes.string.isRequired
  },

  getInitialState() {
    const { dataTransfer } = this.props;
    return {
      type: dataTransfer.type || 'range'
    };
  },

  inputClasses(baseClassNames, rangeType, attr) {
    let classes = `${baseClassNames} ${this.props.classNames}`;

    if (rangeType === "originCellRange" && attr === "worksheetIndex") {
      classes += ' borderLeft';
    }
    if (rangeType === "originCellRange" && attr === "endValue") {
      classes += ' borderRight';
    }
    if (rangeType === "destinationCellRange" && attr === "endValue") {
      classes += ' borderRight';
    }
    return classes;
  },

  handleSelectChange(e) {
    const value = e.target.value;
    const { dataTransfer } = this.props;
    if (value === 'single') {
      dataTransfer.originCellRange.endValue = undefined;
      dataTransfer.destinationCellRange.endValue = undefined;
    }
    dataTransfer.type = value;
    this.setState({ type: value });
  },

  handleSubmit(e) {
    e.preventDefault();
    const { saveRoute, dataTransfer: { type, originCellRange, destinationCellRange } } = this.props;
    const dataTransferParam = {
      type: type,
      origin_cell_range: {
        worksheet_index: originCellRange.worksheetIndex,
        begin_value: originCellRange.beginValue,
        end_value: originCellRange.endValue
      },
      destination_cell_range: {
        worksheet_index: destinationCellRange.worksheetIndex,
        begin_value: destinationCellRange.beginValue,
        end_value: destinationCellRange.endValue
      }
    };

    $.post(saveRoute, { data_transfer: dataTransferParam });
  },

  render() {
    const baseClassNames = "Grid-cell u-size1of8 u-paddingTopBottom1 u-paddingLeftRight0pt5";
    const { dataTransfer, classNames } = this.props;
    const { type } = this.state;

    return (
      <div key={`${dataTransfer.id}-type`} className="Grid">
        <div className={baseClassNames}>
          <select
            className="u-paddingTopBottom0pt5"
            onChange={this.handleSelectChange}
            style={{ width: "100%" }}
            value={type}
          >
            <option value="range">Range</option>
            <option value="single">Single</option>
          </select>
        </div>
        {
          ["originCellRange", "destinationCellRange"].map(rangeType => {
            return (
              ["worksheetIndex", "beginValue", "endValue"].map(attr => {
                const disabled = type === 'single' && attr === 'endValue';
                return (
                  <div
                    className={this.inputClasses(baseClassNames, rangeType, attr)}
                    key={`${dataTransfer.id}-${rangeType}-${attr}`}
                  >
                    <ModelInput
                      model={dataTransfer[rangeType]}
                      style={{width: "100%"}}
                      classNames="u-paddingTopBottom0pt5"
                      attribute={attr}
                      required={!disabled}
                      disabled={disabled}
                    />
                  </div>
                )
              })
            )
          })
        }
        <div className="Grid-cell u-size1of8">
          <input
            type="submit"
            onClick={this.handleSubmit}
            className="submit-button button u-marginTopBottom1pt5 u-paddingTopBottom0pt5"
            style={{ width: "70px" }}
            value="Save"
          />
        </div>
      </div>
    );
  }
});