import urllib.request
import os.path
import traceback
import datetime
import shutil


def download_html(url: str) -> str:
    try:
        with urllib.request.urlopen(url) as f:
            html = f.read().decode('utf-8')
        return html
    except Exception as exc:
        handle_general_exceptions('download', exc)


def write_to_file(path_file: str, string_data: str) -> None:
    try:
        text_file = open(path_file, "a")
        text_file.write(string_data)
        text_file.close()
    except Exception as exc:
        handle_general_exceptions('write_to_file', exc)


def rename_file_if_exists(file_path: str) -> str:
    try:
        if not os.path.isfile(output_filename):
            return

        previous_data = read_file(file_path)
        version_timestamp = find_last_updated_msg("Previous File :", previous_data)
        ct = datetime.datetime.now()
        new_filename = f"{file_path}.{ct}.txt".replace("-", "_").replace(":", "_").replace(" ", "_")
        print(f"Previous Hosts file renamed to filename: {new_filename}")
        os.rename(file_path, new_filename)
        return version_timestamp
    except Exception as exc:
        handle_general_exceptions('rename_file_if_exists', exc)


def find_last_updated_msg(description: str, input_file: str) -> str:
    try:
        found_update_line = input_file.index("# Last updated:")
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
    download_location = "https://someonewhocares.org/hosts/hosts"
    output_filename = "download/hosts"
    copy_location = "C:\\Windows\\System32\\drivers\\etc\\hosts"

    print(f"Downloading from : {download_location}")
    host_data = download_html(download_location)
    previous_version = version_timestamp = rename_file_if_exists(output_filename)
    find_last_updated_msg("New File :", host_data)
    current_version = write_to_file(output_filename, host_data)
    if (previous_version != current_version):
        shutil.copy2(output_filename, copy_location)
    else:
        print('PreviousVersion same as current version')
