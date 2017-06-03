const { PropTypes } = React;

const SelectTransferType = React.createClass({
  propTypes: {
    onSelectChange: PropTypes.func.isRequired,
    attr: PropTypes.string,
    value: PropTypes.string
  },

  handleSelectChange(e) {
    const { onSelectChange, attr } = this.props;
    let obj = {};
    obj[attr] = e.target.value;
    onSelectChange(obj, attr);
  },

  render() {
    return (
      <div className="field">
        <select
          onChange={this.handleSelectChange}
          className="margin-zero-auto"
          value={this.props.value}
        >
          <option value="single">Single</option>
          <option value="range">Range</option>
        </select>
      </div>
    );
  }
});
