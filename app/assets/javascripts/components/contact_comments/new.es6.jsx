const ContactCommentNew = React.createClass({
  propTypes: {
    contactComment: React.PropTypes.object.isRequired,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  getInitialState() {
    return { message: '' };
  },

  handleTextChange(e) {
    this.props.contactComment.message = e.target.value;
    this.setState({ message: e.target.value });
  },

  handleSubmit(e) {
    e.preventDefault();
    $.post('/contact', { contact_comment: this.props.contactComment })
  },

  render() {
    const { contactComment, notice, alert } = this.props;

    return (
      <div className="simple-form u-paddingTop10 u-paddingBottom8">
        <FlashMessage notice={notice} alert={alert} />

        <h2>Contact Us</h2>
        <h3>We appreciate any questions, comments or inquiries</h3>
        <form>
          <div className="field">
            <div>Name:</div>
            <ModelInput model={contactComment} attribute="name" />
          </div>
          <div className="field">
            <div>Email:</div>
            <ModelInput model={contactComment} attribute="email" type="email" />
          </div>
          <div className="field">
            <div>Message:</div>
            <textarea value={this.state.message} onChange={this.handleTextChange}></textarea>
          </div>
          <input
            type="submit"
            onClick={this.handleSubmit}
            className="submit-button button"
            value="Submit"
          />
        </form>
      </div>
    );
  }
});
