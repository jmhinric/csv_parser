require 'axlsx'
require 'ostruct'
# For testing
# def execute; load '/Users/johnhinrichs/dev/csv_parser/app/models/xlsx_builder.rb'; rep = XlsxBuilder.new; File.open('/Users/johnhinrichs/Downloads/rep.xlsx', 'w') { |f| f.write(rep.to_xlsx.to_stream.read) }; end

# This is an unused class that is an example of using 'axlsx' gem to build a spreadsheet
class XlsxBuilder
  def to_xlsx
    # Some column names are dynamically created from hashes from the `raw_row_data`-
    # we need to initialize these before building the spreadsheet.
    # First call `#columns` so the call to `#raw_row_data` correctly populates the columns.
    columns
    raw_row_data

    @styles = {}
    package = Axlsx::Package.new
    # `use_shared_strings = true` is needed for file compatibility with Numbers on OS X
    package.use_shared_strings = true

    wb = package.workbook
    wb.add_worksheet(name: 'Worksheet 1') do |ws|
      ws.sheet_view.show_grid_lines = false
      ws.sheet_view.zoom_scale = 115

      # Register all styles on the worksheet and store them in a `@styles` dictionary
      register_styles { |style| ws.styles.add_style(style) }

      # Add header metadata
      with_placeholder_row { |data_row:, style:| ws.add_row(data_row, { style: style, height: 79.92 }) }
      with_header_metadata { |data_row:, style:| ws.add_row(data_row, style: style) }

      # Add the column headers with row height 1 inch
      ws.add_row(
        columns.map(&:label),
        { style: columns.map { @styles[:column_headers] }, height: 72 }
      )

      # Add auto filters to the column headers
      # This property is set to a string cell range that defines a box, e.g. 'B10:F19'
      ws.auto_filter = column_headers_cell_range

      # Add all data rows
      row_styles = columns.map { |c| @styles[c.style] }
      raw_row_data.each do |data_row|
        row_values = columns.map { |column| data_row.send(column.attr_name) }
        ws.add_row(row_values, style: row_styles)
      end

      # Set column widths
      ws.column_widths(*column_widths)
    end

    package
  end

  private

  # Provides data and styling for row 1
  def with_placeholder_row
    data = ['Placeholder Here']
    (columns.size - 1).times { data << nil }
    data[3] = "Report Title"

    style = [@styles[:placeholder_row_first]]
    (columns.size - 1).times { style << @styles[:placeholder_row_title] }

    yield(data_row: data, style: style)
  end

  # Provides data and styling for rows 2-15
  # We want column headers to begin on row 16
  def with_header_metadata
    data = header_data_service

    # Build initial metadata rows (rows 2-8 of the worksheet)
    rows = [
      [],
      ['Attr1:', data.attr1],
      ['Attr2:', data.attr2],
      ['Reporting Date:', Date.today.strftime("%-m/%-d/%Y")],
      [
        'Reporting Date Range:',
        "#{data.start_date.strftime('%-m/%-d/%Y')} - #{data.end_date.strftime('%-m/%-d/%Y')}"],
      ['Attr3:', data.attr3],
      []
    ]

    # Add variable metadata (rows 9-14)
    ordinals = %w(First Second Third)
    data.variables.each_with_index do |variable, index|
      rows << ["#{ordinals[index]} Variable:", variable.name]
      rows << ["#{ordinals[index]} Label:", variable.label]
    end
    # We need six rows total for variables- two rows per variable, up to three variables.
    # If we don't have three variables, add two empty rows for each missing variable.
    ((3 - data.variables.size) * 2).times { rows << [] }

    # Add one more blank row (row 15)
    rows << []

    # Return data with styles
    rows.each { |r| yield(data_row: r, style: [@styles[:metadata_key], @styles[:metadata_value]]) }
  end

  # TODO: make 16 (row number where column headers start) a constant
  def column_headers_cell_range
    letter_of_last_column = ('A'..'ZZ').to_a[columns.length - 1]
    number_of_last_row = 16 + raw_row_data.size
    "A16:#{letter_of_last_column}#{number_of_last_row}"
  end

  def register_styles
    # Define some commonly used styles
    border = { border: { style: :thin, color: '808080' } }
    border_bottom = { border: { style: :thin, color: '808080', edges: [:bottom] } }
    align_right_horiz = { alignment: { horizontal: :right } }
    align_left_horiz = { alignment: { horizontal: :left } }
    align_center_vert = { alignment: { vertical: :center } }
    align_center_wrapped = { alignment: { vertical: :center, horizontal: :center, wrap_text: true } }
    bold = { b: true }
    calibri = { font_name: 'Calibri' }
    calibri_light = { font_name: 'Calibri Light' }

    # Define the :name and :style for all styles that will go into the `@styles` dictionary
    registry = [
      {
        name: :placeholder_row_first,
        style: merge_to_hash(
          { sz: 24, fg_color: 'b7b7b7' }, align_center_vert, calibri_light, border_bottom
        )
      },
      {
        name: :placeholder_row_title,
        style: merge_to_hash({ sz: 24 }, align_center_vert, calibri_light, border_bottom)
      },
      { name: :metadata_key, style: merge_to_hash(align_right_horiz, bold, calibri) },
      { name: :metadata_value, style: merge_to_hash(align_left_horiz, calibri_light) },
      {
        name: :column_headers,
        style: merge_to_hash(
          { bg_color: '222222', fg_color: 'ffffff' }, align_center_wrapped, calibri, border
        )
      },
      { name: :string, style: merge_to_hash(border, calibri_light) },
      { name: :date, style: merge_to_hash({ format_code: 'MM/DD/YYYY' }, border, calibri_light) },
      { name: :units, style: merge_to_hash({ format_code: '#,##0' }, border, calibri_light) },
      { name: :dollars, style: merge_to_hash({ format_code: '$#,##0.00' }, border, calibri_light) }
    ]

    # Add each named set of styles to the `@styles` dictionary
    registry.each { |opts| @styles[opts[:name]] = yield opts[:style] }
  end

  # Combines an arbitrary number of hashes into a single hash
  def merge_to_hash(*attrs)
    attrs[1..-1].inject(attrs.first) { |memo, attr| memo.merge(attr) }
  end

  def column_widths
    # First entry gives length for the longest label of the metadata labels
    [30] + (1..columns.length - 1).to_a.map { 15 }
  end

  def columns
    @columns ||= [
      OpenStruct.new(
        attr_name: :purchase_date,
        label: "Purchase Date",
        style: :date
      ),
      OpenStruct.new(
        attr_name: :metric_units,
        label: "Metric Units",
        style: :units
      ),
      OpenStruct.new(
        attr_name: :metric_name,
        label: "Metric Name",
        style: :string
      ),
      OpenStruct.new(
        attr_name: :revenue,
        label: "Revenue",
        style: :dollars
      )
    ]
  end

  ################################################################################################
  # Below are the data sources/services needed by #to_xlsx to generate this report

  def raw_row_data
    @raw_row_data ||= begin
      raw = [
        OpenStruct.new(
          purchase_date: '2017-05-01',
          metric_units: 1000,
          metric_name: 'Metric Name1',
          revenue: 10_005.50,
          us_sales: { 'chairs' => 5, 'lamps' => 10 },
          international_sales: { 'chairs' => 6, 'lamps' => 16 }
        ),
        OpenStruct.new(
          purchase_date: '2017-06-01',
          metric_units: 5000,
          metric_name: 'Metric Name2',
          revenue: 25_006.60,
          us_sales: { 'chairs' => 27, 'lamps' => 38, 'stools' => 49 },
          international_sales: { 'chairs' => 17, 'lamps' => 28 }
        )
      ]

      us_sales_keys = raw.flat_map(&:us_sales).compact.flat_map(&:keys).uniq;
      international_sales_keys = raw.flat_map(&:international_sales).compact.flat_map(&:keys).uniq;

      add_sales_columns(us_sales_keys, international_sales_keys)

      # Add getters for each us and international sales column, corresponding to each column
      # `attr_name` added to `#columns` by `#add_sales_columns`
      raw.map do |r|
        OpenStruct.new(r).tap do |os|
          us_sales_keys.each { |k| os[us_sales_label(k)] = r.us_sales[k] }
          international_sales_keys.each { |k| os[international_sales_label(k)] = r.international_sales[k] }
        end
      end
    end
  end

  # Adds columns for each us and international sale
  def add_sales_columns(us_sales_keys, international_sales_keys)
    us_sales_labels = us_sales_keys.map { |k| us_sales_label(k) }
    international_sales_labels = international_sales_keys.map { |k| international_sales_label(k) }

    # Add in all us and international sales to the end of the columns, sorted by name
    # to keep us and international versions of the same sale name together
    (us_sales_labels + international_sales_labels).sort.each do |n|
      @columns << OpenStruct.new(
        attr_name: n,
        label: n,
        style: :units
      )
    end
  end

  def us_sales_label(name)
    name + " - US Sale"
  end

  def international_sales_label(name)
    name + " - International Sale"
  end

  def header_data_service
    data_source = OpenStruct.new(
      attr1: 'foo',
      attr2: 'bar',
      attr3: 'baz',
      variables: [
        OpenStruct.new(name: 'A Variable Name1', label: 'Label1'),
        OpenStruct.new(name: 'A Variable Name2', label: 'Label2')
      ]
    )
    OpenStruct.new(
      attr1: data_source.attr1,
      attr2: data_source.attr2,
      attr3: data_source.attr3,
      start_date: Date.new(2017, 10, 21),
      end_date: Date.new(2017, 10, 22),
      variables: data_source.variables.map do |v|
        OpenStruct.new(name: v.name, label: v.label)
      end
    )
  end
end
