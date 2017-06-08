const { PropTypes } = React;

const BackNav = ({ template }) => (
  <div className="small-link u-paddingTop5 u-paddingBottom3">
    <a href={`/templates/${template.id}`}>{`Back to ${template.name}`}</a>
  </div>
);

const DataTransferIndex = React.createClass({

  propTypes: {
    template: PropTypes.object.isRequired,
    originFiles: React.PropTypes.array.isRequired,
    notice: React.PropTypes.string,
    alert: React.PropTypes.string
  },

  render() {
    const { template, originFiles, notice, alert } = this.props;

    return (
      <main id="template-show" className="grid-paper-background">
        <div className="wrapper-seventy">
          <BackNav template={template} />
          <FlashMessage notice={notice} alert={alert} />

          <section className="template-info">
            <div className="template-header">
              <h2>{template.name}</h2>
              <p>{template.description}</p>
            </div>
          </section>

          <section className="data-transfers-info">
            <h2>Data transfers:</h2>

            {
              originFiles.map((originFile) => {
                return (
                  <DataTransferTable
                    key={originFile.id}
                    originFile={originFile}
                    template={template}
                  />
                );
              })
            }
          </section>

          <BackNav template={template} />
        </div>
      </main>
    );
  }
});
