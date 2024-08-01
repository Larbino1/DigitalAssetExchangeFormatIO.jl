struct DAEParserConfig{L<:AbstractLogger}
    logger::L
end

function DAEParserConfig() # Default config
    logger = ConsoleLogger(stderr, Logging.Warn)
    return DAEParserConfig{typeof(logger)}(logger)
end