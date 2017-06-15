const { PropTypes } = React;

const BackNav = ({ template }) => (
  <div className="u-paddingTop5">
    <a href={`/templates/${template.id}`} className="small-link">{`Back to ${template.name}`}</a>
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
      <main>
        <FlashMessage notice={notice} alert={alert} />
        <div className="wrapper-seventy">
          <BackNav template={template} />

          <section className="u-textCenter u-paddingTop10 u-paddingBottom4">
            <h2>{template.name}</h2>
            <p>{template.description}</p>
          </section>

          <section>
            <div className="u-textCenter">
              <h2>Data transfers:</h2>
              <span style={{ fontSize: "12px" }}>
                * Worksheet index numbering begins at zero.
              </span>
            </div>


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
