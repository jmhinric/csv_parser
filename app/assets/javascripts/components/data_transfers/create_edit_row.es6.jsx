const { PropTypes } = React;

const DataTransferCreateEditRow = React.createClass({
  propTypes: {
    dataTransfer: PropTypes.object.isRequired,
    classNames: PropTypes.string.isRequired,
    templateId: PropTypes.string.isRequired,
    originFileId: PropTypes.string.isRequired,
    handleToggleEdit: PropTypes.func
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
    const {
      templateId,
      originFileId,
      dataTransfer,
      dataTransfer: { type, originCellRange, destinationCellRange }
    } = this.props;
    const baseRoute = `/templates/${templateId}`;
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

    if (dataTransfer.id) {
      $.ajax({
        type: "PATCH",
        url: baseRoute + `/data_transfers/${dataTransfer.id}`,
        data: { data_transfer: dataTransferParam }
      })
    }
    else {
      $.post(
        baseRoute + `/origin_files/${originFileId}/data_transfers`,
        { data_transfer: dataTransferParam }
      );
    }
  },

  render() {
    const baseClassNames = "Grid-cell u-size1of8 u-paddingTopBottom1 u-paddingLeftRight0pt5";
    const { dataTransfer, classNames, handleToggleEdit } = this.props;
    const { type } = this.state;

    return (
      <div key={`${dataTransfer.id}-type`} className="Grid">
        <div className={baseClassNames}>
          <select
            className={`u-paddingTopBottom0pt5 ${handleToggleEdit && 'cursor-not-allowed'}`}
            onChange={this.handleSelectChange}
            style={{ width: "100%" }}
            value={type}
            disabled={handleToggleEdit}
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
          <div className="u-marginTop1pt5">
            <input
              type="submit"
              onClick={this.handleSubmit}
              className={`u-posAbsolute submit-button button u-marginTopBottom0 u-paddingTopBottom0pt5 ${handleToggleEdit ? 'u-marginLeft3' : 'u-marginLeft0pt75'}`}
              style={{ width: "70px" }}
              value="Save"
            />
            { handleToggleEdit &&
              <span
                onClick={() => handleToggleEdit(dataTransfer.id)}
                className="u-marginLeft0pt75 u-marginTop1 u-posAbsolute small-link"
              >
                Cancel
              </span>
            }
          </div>
        </div>
      </div>
    );
  }
});