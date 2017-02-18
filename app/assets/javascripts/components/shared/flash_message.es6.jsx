const FlashMessage = React.createClass({
  proptypes: {
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  render() {
    const { notice, alert } = this.props;
    const message = notice ? notice : alert;
    const classNames = `flash-message ${notice ? 'success' : 'error'}`;
    return (
      <div className="flash-message-wrapper">
        { message &&
          <p className={classNames}>{message}</p>
        }
      </div>
    );
  }
});
