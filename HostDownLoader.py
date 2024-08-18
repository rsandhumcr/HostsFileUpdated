import urllib.request
import os.path
import traceback
import datetime
import shutil
import configparser
def download_html(url: str) -> str:
    try:
        with urllib.request.urlopen(url) as f:
            html = f.read().decode('utf-8')
        return html
    except Exception as exc:
        handle_general_exceptions('download', exc)


def write_to_file(path_file: str, string_data: str) -> None:
    try:
        text_file = open(path_file, "w")
        text_file.write(string_data)
        text_file.close()
    except Exception as exc:
        handle_general_exceptions('write_to_file', exc)

def get_file_version(search_term: str, file_path: str) -> str:
    try:
        if not os.path.isfile(output_filename):
            return

        previous_data = read_file(file_path)
        version_timestamp = find_last_updated_msg(search_term,"Previous File :", previous_data)
        return version_timestamp
    except Exception as exc:
        handle_general_exceptions('get_file_version', exc)

def rename_file_if_exists(file_path: str) -> None:
    try:
        if not os.path.isfile(output_filename):
            return
        ct = datetime.datetime.now()
        new_filename = f"{file_path}.{ct}.txt".replace("-", "_").replace(":", "_").replace(" ", "_")
        os.rename(file_path, new_filename)
    except Exception as exc:
        handle_general_exceptions('rename_file_if_exists', exc)


def find_last_updated_msg(search_term: str, description: str, input_file: str) -> str:
    try:
        found_update_line = input_file.index(search_term)
        end_of_line = input_file.index('\n', found_update_line, found_update_line + 100)
        version_timestamp = input_file[found_update_line:end_of_line]
        print(description + ' ' + version_timestamp)
        return version_timestamp
    except Exception as exc:
        handle_general_exceptions('find_last_updated_msg', exc)


def read_file(path_file: str) -> str:
    try:
        text_file = open(path_file, "r")
        file_data = text_file.read()
        text_file.close()
        return file_data
    except Exception as exc:
        handle_general_exceptions('read_file', exc)


def handle_general_exceptions(method_name: str, exception: Exception) -> None:
    print(f'HostFileDownloader Method : {method_name}')
    print('ex : ', exception)
    tb = traceback.TracebackException.from_exception(exception)
    print(''.join(tb.stack.format()))


if __name__ == '__main__':
    config = configparser.ConfigParser()

    #config.read("someonewhocares.ini")
    config.read("1hosts.ini")

    download_location = config.get('Default', 'url')
    output_filename = config.get('Default', 'output_path')
    search_term = config.get('Default', 'search_term')

    copy_location = "C:\\Windows\\System32\\drivers\\etc\\hosts"

    print(f"Downloading from : {download_location}")
    host_data = download_html(download_location)
    previous_version = get_file_version(search_term, output_filename)
    current_version = find_last_updated_msg(search_term, "Current File :", host_data)
    if previous_version != current_version:
        rename_file_if_exists(output_filename)
        write_to_file(output_filename, host_data)
        shutil.copy2(output_filename, copy_location)
        print(f'Host updated : {current_version}')
    else:
        print(f'Previous version same as current : {current_version}')
