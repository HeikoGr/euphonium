class WebRadioPlugin : Plugin
    def init()
        self.apply_default_values()
        self.name = "webradio"
        self.theme_color = "#d2c464"
        self.display_name = "Web Radio"
        self.type = "plugin"
        self.has_web_app = true
    end

    def make_form(ctx, state)
        ctx.create_group('webradio', { 'label': 'General' })

        ctx.text_field('radioBrowserUrl', {
            'label': "Radio Browser instance url",
            'default': "http://webradio.radiobrowser.com/api/v1/stations/",
            'group': 'webradio'
        })
    end


    def on_event(event, data)
        if event == EVENT_SET_PAUSE
            webradio_set_pause(data)
        end
    end
end

euphonium.register_plugin(WebRadioPlugin())

# HTTP Handlers
http.handle('POST', '/webradio', def(request)
    var body = request.json_body()

    euphonium.update_song({
        'songName': body["stationName"],
        'artistName': 'Internet Radio',
        'sourceName': 'webradio',
        'icon': body['favicon'],
        'albumName': body['codec']
    })
    webradio_queue_url(body['stationUrl'], (body["codec"] == "AAC" || body["codec"] == "AAC+"))
    euphonium.set_status('playing')
    request.write_json({ 'status': 'playing'}, 200)
end)
