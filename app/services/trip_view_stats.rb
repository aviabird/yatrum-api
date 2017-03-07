# Service to Calculate View Data Like Medium.com for a particular trip.
# Returns dates as labels and view counts for a particular date as data series.
# Call => TripViewStats.new(id: some_trip.id)
# TripViewStats.call
class TripViewStats
  attr_reader :result, :impressions

  def initialize(id: nil)
    @id = id
    @impressions = nil
    @range = { start_date: Date.new, end_date: Date.new }
    @views = []
    @dates = []
    @result = {status: false}
  end

  def call
    begin
      # Should return unique impressions as per ip
      retrive_all_trip_impressions
      # TODO: Re-Think over the below if-else condition
      if impressions.present?
        calc_date_range
        calc_graph_labels_and_series_data
      else
        @dates = [Trip.find(@id).created_at]
        @views = [0]
      end
      set_result(status: true, data: { labels: @dates, series: @views })
    rescue => e
      set_result(status: false, data: e.message)
    ensure
      return @result
    end    
  end

  private
  
  def retrive_all_trip_impressions
    @impressions = Trip.find(@id)
                       .impressions
                       .select('DISTINCT ON(ip_address) *')

    # Impression
    # .find_by_sql("select DISTINCT ON(ip_address) * from impressions where impressionable_id = #{@id}")
  end

  def calc_date_range
    @range[:start_date] = impression_date_by_order(:minimum)
    @range[:end_date]   = impression_date_by_order(:maximum)
  end

  # order_type: => :minimum || :maximum
  def impression_date_by_order(order_type = :minimum)
   # impressions.order(created_at: order_type)
   #            .limit(1)
   #            .first
   #            .created_at.to_date

   impressions.send(order_type, :created_at).to_date
  end

  # Here labels is dates and series_data is views
  # E.g => 
  # @views => [11, 111, 222]
  # @dates => [1 march 2017, 2 march 2017, 3 march 2017]
  def calc_graph_labels_and_series_data
    # Index as we are going to increment 
    # it for every iteration
    index_date = @range[:start_date]

    (index_date..@range[:end_date]).each do |idate|
      count = impressions
              .where(created_at: ((idate.at_beginning_of_day)..(idate.end_of_day)))
              .length
      @views.push(count)
      @dates.push(idate)
      index_date = index_date + 1.day
    end
  end

  # Set Final output of service
  def set_result(status: false, data: nil)
    @result[:status] = status

    if data.is_a? String
      @result[:error] = data
    else
      @result[:labels] = data[:labels]
      @result[:series] = data[:series]
    end
  end
end
