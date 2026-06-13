#!/bin/bash
while true; do
    flask db upgrade
    if [[ "$?" == "0" ]]; then
        break
    fi
    echo Upgrade command failed, retrying in 5 secs...
    sleep 5
done
python -c "from app import create_app; from app.models import Post; app = create_app(); app.app_context().push(); Post.reindex()"
exec gunicorn -b :5000 --access-logfile - --error-logfile - microblog:app