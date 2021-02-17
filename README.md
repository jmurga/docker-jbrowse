# Docker image for JBrowse on nginx
Configurable docker image for [GMOD's JBrowse](https://github.com/gmod/jbrowse/).

[http://jbrowse.org/](http://jbrowse.org/)


## Example:

A `docker-compose.yml` file is provided for your convenience, allowing you to boot up the example quite quickly:

```console
$ docker-compose up
```

## Mount point


## Startup Scripts

## Environment Variables

There are a couple environment variables available to startup scripts:

Variable       | Value/Use
-------------- | ---
`JBROWSE`      | The location of the jbrowse installation, including the `index.html`
`JBROWSE_DATA` | Location for the `sample_data` folder which contains publicised data
`DATA_DIR`     | Location of mounted data

## Licence (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
