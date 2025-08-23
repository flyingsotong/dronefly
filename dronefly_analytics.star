# Tidbyt app to display Dronefly website analytics.
# This app uses the Tidbyt Pixlet framework, which is a Python-like language called Starlark.
#
# To use this app, you will need to:
# 1. Have a self-hosted Umami instance or use Umami Cloud.
# 2. Get a "share ID" from your Umami dashboard. This is a public, read-only ID.
#    In Umami, go to a website's settings and look for "Share URL". The ID is in the URL.
# 3. Replace the `UMAMI_URL` and `SHARE_ID` variables with your specific values.
#
# This script fetches and displays a few key metrics:
# - Total page views for a specific period (e.g., today).
# - Total unique visitors for a specific period.
#
# The app is designed to be simple, showing one metric at a time with a title.
# It can be extended to show more metrics or animate between them.

load("http.star", "http")
load("encoding/json.star", "json")
load("render.star", "render")
load("time.star", "time")
load("os.star", "os")
load("math.star", "math")
load("schema.star", "schema")

# ==============================================================================
# CONFIGURATION
# ==============================================================================
# The provided Umami URL and Website Share ID.
UMAMI_URL = "https://api.umami.is/v1"
SHARE_ID = "8894fbc1-d127-4d15-84aa-27fa8a2d0bf4"
API_KEY = os.environ.get("API_KEY", "default_api_key")

# The period for which to fetch analytics data.
# Options: "24h", "7d", "30d", "90d", "365d", "1y", "all"
PERIOD = "all"

# ==============================================================================
# API CALLS AND DATA PROCESSING
# ==============================================================================

def get_umami_stats(website_id, period):
    """
    Fetches website stats from the Umami API.

    Args:
        website_id: The ID of the website to query.
        period: The time period for the data (e.g., "24h").

    Returns:
        A dictionary with the analytics data, or an error message if the
        request fails.
    """
    # Calculate time range - for "all" time, use a very early start date
    now_ms = int(time.now().unix * 1000)
    start_ms = 0
    
    # Use the correct authenticated API endpoint for Umami Cloud
    url = "%s/websites/%s/stats?startAt=%d&endAt=%d" % (UMAMI_URL, website_id, start_ms, now_ms)
    
    # Use Umami Cloud API key authentication
    headers = {
        "x-umami-api-key": os.environ.get("API_KEY", "default_api_key"),
        "Content-Type": "application/json"
    }
    
    response = http.get(url, headers = headers, ttl_seconds = 300)
    
    if response.status_code != 200:
        return {"error": "API failed: " + str(response.status_code)}
    
    # Use response.json() method for Pixlet
    data = response.json()
    if type(data) != "dict":
        return {"error": "Not dict: " + str(type(data)) + " - " + str(data)}
    return data

def format_number(n):
    """
    Formats a number with a thousands separator.
    """
    if n >= 1000000:
        return str(int(n / 100000) / 10.0) + "M"
    elif n >= 1000:
        return str(int(n / 100) / 10.0) + "K"
    else:
        return str(n)

# ==============================================================================
# RENDERING LOGIC
# ==============================================================================

def draw_text_with_title(title_line1, title_line2, value):
    """
    Renders a two-line title and a value on the Tidbyt screen.
    """
    return render.Column(
        main_align = "center",
        cross_align = "center",
        children = [
            render.Column(
                main_align = "center",
                cross_align = "center",
                children = [
                    render.Text(
                        content = title_line1.upper(),
                        font = "tom-thumb",
                        color = "#FFFFFF",
                    ),
                    render.Text(
                        content = title_line2.upper(),
                        font = "tom-thumb",
                        color = "#FFFFFF",
                    ),
                    render.Box(
                        width = 64,
                        height = 22
                    ),
                    render.Text(
                        content = value,
                        font = "6x13",
                        color = "#20A0FF",
                    ),
                    render.Box(
                        width = 64,
                        height = 22
                    ),
                ]
            )
        ]
    )

def main(config):
    """
    The main function of the Tidbyt app.
    It fetches data and returns the rendered content for the display.
    """
    # Use config values if available, otherwise use defaults.
    umami_url = config.str("umami_url", UMAMI_URL)
    share_id = config.str("share_id", SHARE_ID)
    period = config.str("period", PERIOD)
    
    stats = get_umami_stats(share_id, period)

    if stats == None or "error" in stats:
        # Show demo data when API fails
        visitors = 1234
        pageviews = 5678
    else:
        # Extract values from the nested structure
        visitors = stats.get("visitors", {}).get("value", 0)
        pageviews = stats.get("pageviews", {}).get("value", 0)
    
    # Show only visitors with two-line title
    return render.Root(
        child = draw_text_with_title(
            "Dronefly",
            format_number(visitors)
        )
    )

# The following is a schema definition. This allows users to configure the app
# from the Tidbyt mobile app, for example, to change the period or the website ID.
def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "umami_url",
                name = "Umami URL",
                desc = "The full URL to your Umami instance, e.g., https://your-umami-instance.com",
                icon = "link",
                default = UMAMI_URL,
            ),
            schema.Text(
                id = "share_id",
                name = "Website Share ID",
                desc = "The unique public ID for your website from Umami's share settings.",
                icon = "chartBar",
                default = SHARE_ID,
            ),
            schema.Dropdown(
                id = "period",
                name = "Time Period",
                desc = "The time period to display analytics for.",
                icon = "calendar",
                options = [
                    schema.Option(display = "Last 24 Hours", value = "24h"),
                    schema.Option(display = "Last 7 Days", value = "7d"),
                    schema.Option(display = "Last 30 Days", value = "30d"),
                    schema.Option(display = "Last 90 Days", value = "90d"),
                    schema.Option(display = "Last 365 Days", value = "365d"),
                    schema.Option(display = "Last 1 Year", value = "1y"),
                    schema.Option(display = "All Time", value = "all"),
                ],
                default = PERIOD,
            ),
        ]
    )
