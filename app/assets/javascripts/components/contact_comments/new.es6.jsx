const ContactCommentNew = React.createClass({
  propTypes: {
    contactComment: React.PropTypes.object.isRequired,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  handleMessageChange(e) {
    this.props.contactComment.message = e.target.value;
  },

  handleSubmit(e) {
    e.preventDefault();
    $.post('/contact', { contact_comment: this.props.contactComment })
  },

  render() {
    const { contactComment, notice, alert } = this.props;

    return (
      <div className="simple-form">
        <FlashMessage notice={notice} alert={alert} />

        <h2>Contact Us</h2>
        <div id="email-form-wrapper">
          <div className="email-form">
            <h3>We appreciate any questions, comments or inquiries</h3>
            <form className="nifty_form">
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
                <textarea onChange={this.handleMessageChange}></textarea>
              </div>
              <input
                type="submit"
                onClick={this.handleSubmit}
                className="submit-button button"
                value="Submit"
              />
            </form>
          </div>
        </div>
      </div>
    );
  }
});
