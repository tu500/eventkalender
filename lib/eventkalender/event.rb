class Eventkalender
  # Represents a voc event.
  #
  # @!attribute [rw] start_date
  #   @param date [String] witch represents start date of the event
  #   @return [Date] event start date
  # @!attribute [rw] end_date
  #   @param date [String] witch represents end date of the event
  #   @return [Date] event end date
  # @!attribute [rw] name
  #   @return [String] event name
  # @!attribute [rw] location
  #   @return [String] event location
  # @!attribute [rw] description
  #   @return [String] event description, in general it's used for event url
  # @!attribute [rw] short_name
  #   @return [String] event synonym
  # @!attribute [rw] wiki_path
  #   @return [String] event path in voc wiki
  # @!attribute [rw] streaming
  #   @return [String] event streaming status
  class Event

    attr_reader :start_date, :end_date
    attr_accessor :name, :location, :description, :short_name, :wiki_path, :streaming

    # Create new event object
    #
    # @param options [Hash] to create an event with.
    # @option options [String] :name The event name
    # @option options [String] :location The event location
    # @option options [String] :start_date Events start date
    # @option options [String] :end_date Events end date
    # @option options [String] :description The event description
    # @option options [String] :wiki_path The event path in c3voc wiki
    # @option options [String] :short_name The event short name
    # @option options [String] :streaming Planed event streaming status
    def initialize(options = {})
      @name        = options[:name]
      @location    = options[:location]
      @start_date  = check_date_input(options[:start_date])
      @end_date    = check_date_input(options[:end_date])
      @description = options[:description]
      # optional
      @wiki_path   = options[:wiki_path]
      @short_name  = options[:short_name]
      @streaming   = options[:streaming]
    end

    # Setter for start_date.
    #
    # @example Setting events start date.
    #   event.start_date = "2014-05-23" #=> "2014-05-23"
    #
    # @param date [String] start date of a event to set
    # @return [Date] converted and set start date
    def start_date=(date)
      @start_date = check_date_input(date)
    end

    # Setter for end_date.
    #
    # @example Setting events end date.
    #   event.end_date = "2014-05-23" #=> "2014-05-23"
    #
    # @param date [String] end date of a event to set
    # @return [Date] converted and set end date
    def end_date=(date)
      @end_date = check_date_input(date)
    end

    # Convert event to ical.
    #
    # @example Convert event to ical object.
    #   event.to_ical #=>  #<Icalendar::Event:0x00000002f02ee8 @name="VEVENT" … >
    #
    # @return [Icalendar::Event] converted ical event
    def to_ical
      Icalendar::Event.new.tap { |e|
        e.summary     = @name
        e.location    = @location
        e.start       = @start_date
        e.end         = @end_date + 1 # TODO: DateTime would maybe a better choice
        e.description = @description
      }
    end

    protected

    # Convert dates into real date object
    #
    # @param date [String] date which needs to converted
    #
    # @return [Date] a valid date object if everything is fine
    # @return [nil] if input was not a valid date
    def check_date_input(date)
      Eventkalender::Parser.date(date)
    end

  end
end