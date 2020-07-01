exports.headers = {
    'Sameorigin': 'lax',
    'Cache-Control': 'must-revalidate',
    'Access-Control-Allow-Origin':
        'http://localhost:3000',
    'Access-Control-Request-Headers': 'http://localhost:3000',
    'Access-Control-Allow-Methods': "POST, GET, OPTIONS, PUT, DELETE",
}
exports.status = 200