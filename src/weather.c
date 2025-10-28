#include <curl/curl.h>
#include <stdio.h>
#include <stdlib.h>

/*int fetch_geocode() {
	char geocode_url[] = "https://geocoding-api.open-meteo.com/v1/search?name=Detroit&count=10&language=en&format=json";
	CURL *curl = curl_easy_init();
	
	if (!curl) {
		fprintf(stderr, "init failed\n");
		return EXIT_FAILURE;
	}
	
	curl_easy_setopt(curl, CURLOPT_URL, geocode_url);
	curl_easy_setopt(curl, CURLOPT_URL, fetch_coordinates);
	
	CURLcode result = curl_easy_perform(curl);
	
	if (result != CURLE_ok) {
		fprintf(stderr, "%s\n", curl_easy_strerror(result));
	}
	
}*/

size_t write_data(char *buffer, size_t itemsize, size_t nitems, void *stream) {
	size_t written = fwrite(buffer, itemsize, nitems, stream);
	return written;
}

void fetch_forecast(/*char *latitude[], char *longitude[]*/) {
	char forecast_url[] = "https://api.open-meteo.com/v1/forecast?latitude=42.331&longitude=-83.046&hourly=temperature_2m,relative_humidity_2m,dew_point_2m,apparent_temperature,precipitation_probability,precipitation,rain,showers,snowfall,snow_depth,weather_code,surface_pressure,visibility,wind_speed_10m,wind_direction_10m,wind_gusts_10m&current=temperature_2m,relative_humidity_2m,apparent_temperature,snowfall,showers,precipitation,weather_code,surface_pressure,wind_gusts_10m,wind_direction_10m,wind_speed_10m,rain&timezone=auto&forecast_days=3&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch";
	CURL *curl = curl_easy_init();
	if (!curl) {
		fprintf(stderr, "init failed\n");
	}

	curl_easy_setopt(curl, CURLOPT_URL, forecast_url);
	//curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);
	
	FILE *file;
	file = fopen("forecast.json", "w");
	
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, file);
	
	CURLcode result = curl_easy_perform(curl);
	if (result != CURLE_OK) {
		fprintf(stderr, "%s\n", curl_easy_strerror(result));
	}

	fclose(file);
	
	curl_easy_cleanup(curl);
}

int main(/*int argc, char *argv[]*/){
	fetch_forecast();
	return EXIT_SUCCESS;
}
