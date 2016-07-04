#include "b2file.h"

QObject* B2File::singleton(QQmlEngine *engine, QJSEngine *scriptEngine){
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    static B2File* _singleton=nullptr;
    if(!_singleton)
        _singleton=new B2File;
    return _singleton;
}

QString B2File::resourcePath(QString file){
    return QString(":/")+file;
}

QString B2File::dataPath(QString file){
    QString path=QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(path);
    if(!dir.exists())
        dir.mkpath(path);
    return path+'/'+file;
}

bool B2File::exist(QString path){
    return QFile(path).exists();
}

bool B2File::write(QString path, QString data){
    QFile f(path);
    if(!f.open(QIODevice::WriteOnly)) return false;
    if(f.write(data.toUtf8())==-1){
        f.close();
        return false;
    }
    return true;
}

QString B2File::read(QString path){
    QFile f(path);
    if(!f.exists()) return "";
    if(!f.open(QIODevice::ReadOnly)) return "";
    QByteArray byteArray(f.readAll());
    if(byteArray.isEmpty()){
        f.close();
        return "";
    }
    return QString(byteArray);
}

bool B2File::remove(QString path){
    QFile f(path);
    return f.remove();
}
