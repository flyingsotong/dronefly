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
load("json.star", "json")
load("render.star", "render")
load("time.star", "time")
load("math.star", "math")

# ==============================================================================
# CONFIGURATION
# ==============================================================================
# The provided Umami URL and Website Share ID.
UMAMI_URL = "https://eu.umami.is"
SHARE_ID = "8894fbc1-d127-4d15-84aa-27fa8a2d0bf4"

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
    url = "%s/api/share/%s/stats?url=true&unit=day&period=%s" % (UMAMI_URL, website_id, period)
    
    # Tidbyt's http.get is a non-blocking request, but the script will wait.
    response = http.get(url, headers = {"x-umami-share": website_id})
    
    if response.status_code != 200:
        return {"error": "API request failed with status code: " + str(response.status_code)}
    
    try:
        data = json.decode(response.body)
        if type(data) != "dict":
            return {"error": "Failed to decode JSON."}
        return data
    except Exception as e:
        return {"error": "Failed to decode JSON: " + str(e)}

def format_number(n):
    """
    Formats a number with a thousands separator.
    """
    if n >= 1000000:
        return "%.1fM" % (n / 1000000.0)
    elif n >= 1000:
        return "%.1fK" % (n / 1000.0)
    else:
        return "%d" % n

# ==============================================================================
# RENDERING LOGIC
# ==============================================================================

def draw_text_with_title(title, value):
    """
    Renders a title and a value on the Tidbyt screen.
    """
    return render.Column(
        main_align = "center",
        cross_align = "center",
        children = [
            render.Box(
                height = 16,
                child = render.Text(
                    content = title.upper(),
                    font = "CG-pixel-3x5-mono",
                    height = 10,
                    color = "#FFFFFF",
                ),
            ),
            render.Text(
                content = value,
                font = "6x13",
                color = "#20A0FF",
            ),
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

    if "error" in stats:
        return render.Root(
            child = render.Box(
                padding = 4,
                child = render.WrappedText(
                    content = stats["error"],
                    font = "tom-thumb",
                    color = "#FF0000",
                    align = "center",
                )
            )
        )

    visitors = stats.get("visitors", 0)
    pageviews = stats.get("pageviews", 0)
    
    # Create frames for different metrics
    visitors_frame = draw_text_with_title(
        "Visitors",
        format_number(visitors)
    )
    
    pageviews_frame = draw_text_with_title(
        "Page Views", 
        format_number(pageviews)
    )

    # Animate between the two metrics
    return render.Root(
        child = render.Animation(
            children = [
                visitors_frame,
                pageviews_frame,
            ]
        )
    )

# The following is a schema definition. This allows users to configure the app
# from the Tidbyt mobile app, for example, to change the period or the website ID.
def get_schema():
    load("schema.star", "schema")
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
