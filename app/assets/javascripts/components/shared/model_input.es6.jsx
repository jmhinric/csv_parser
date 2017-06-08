const { PropTypes } = React;

const ModelInput = React.createClass({
  propTypes: {
    model: PropTypes.object.isRequired,
    attribute: PropTypes.string.isRequired,
    classNames: PropTypes.string,
    placeholder: PropTypes.string,
    type: PropTypes.string,
    style: PropTypes.object,
    disabled: PropTypes.bool
  },

  getDefaultProps() {
    return {
      type: 'text',
      style: {}
    };
  },

  handleChange(e) {
    const { model, attribute } = this.props;
    model[attribute] = e.target.value;
  },

  render() {
    const {
      classNames,
      placeholder,
      type,
      style,
      required,
      model,
      attribute,
      disabled
    } = this.props;

    return (
      <input
        style={style}
        type={type}
        value={model[attribute]}
        required={required || false}
        placeholder={placeholder}
        className={classNames}
        onChange={this.handleChange}
        disabled={disabled}
      />
    );
  }
});
