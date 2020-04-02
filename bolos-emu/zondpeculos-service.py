#!/usr/bin/env python3
#  ********************************************************************************
#  *  (c) 2020 ZondaX GmbH
#  *
#  *  Licensed under the Apache License, Version 2.0 (the "License");
#  *  you may not use this file except in compliance with the License.
#  *  You may obtain a copy of the License at
#  *
#  *      http://www.apache.org/licenses/LICENSE-2.0
#  *
#  *  Unless required by applicable law or agreed to in writing, software
#  *  distributed under the License is distributed on an "AS IS" BASIS,
#  *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  *  See the License for the specific language governing permissions and
#  *  limitations under the License.
#  *******************************************************************************
# !flask/bin/python
from flask import Flask, request

app = Flask(__name__)

SERVICE_ADDR = '0.0.0.0'
SERVICE_HOST = 9997


@app.route('/')
def index():
    return "Zondpeculos!"

#  curl -X POST -F file=@example.app http://localhost:9997/upload_app
@app.route("/upload_app", methods=['POST','PUT'])
def upload_app():
    file = request.files['file']
    file.save('/tmp/current.app')
    return "app uploaded"

if __name__ == '__main__':
    print(f'Zondpeculos started at {SERVICE_ADDR}:{SERVICE_HOST}')
    app.run(host=SERVICE_ADDR, port=SERVICE_HOST, debug=True)
