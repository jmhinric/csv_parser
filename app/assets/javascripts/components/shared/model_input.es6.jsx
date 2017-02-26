const ModelInput = React.createClass({
  propTypes: {
    model: React.PropTypes.object.isRequired,
    attribute: React.PropTypes.string.isRequired,
    classNames: React.PropTypes.string,
    placeholder: React.PropTypes.string,
    type: React.PropTypes.string,
    style: React.PropTypes.object
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
    const { classNames, placeholder, type, style, required } = this.props;

    return (
      <input
        style={style}
        type={type}
        required={required || false}
        placeholder={placeholder}
        className={classNames}
        onChange={this.handleChange}
      />
    );
  }
});
