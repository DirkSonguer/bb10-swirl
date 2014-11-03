/****************************************************************************
** Meta object code from reading C++ file 'FileUpload.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/FileUpload.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'FileUpload.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_FileUpload[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      18,   12,   11,   11, 0x08,

 // methods: signature, parameters, type, tag, flags
     106,   52,   47,   11, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_FileUpload[] = {
    "FileUpload\0\0reply\0fileUploaded(QNetworkReply*)\0"
    "bool\0v,checkinId,oauth_token,publicFlag,fileName,serverUrl\0"
    "uploadFile(QByteArray,QByteArray,QByteArray,QByteArray,QString,QString"
    ")\0"
};

void FileUpload::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        FileUpload *_t = static_cast<FileUpload *>(_o);
        switch (_id) {
        case 0: _t->fileUploaded((*reinterpret_cast< QNetworkReply*(*)>(_a[1]))); break;
        case 1: { bool _r = _t->uploadFile((*reinterpret_cast< const QByteArray(*)>(_a[1])),(*reinterpret_cast< const QByteArray(*)>(_a[2])),(*reinterpret_cast< const QByteArray(*)>(_a[3])),(*reinterpret_cast< const QByteArray(*)>(_a[4])),(*reinterpret_cast< const QString(*)>(_a[5])),(*reinterpret_cast< const QString(*)>(_a[6])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData FileUpload::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject FileUpload::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_FileUpload,
      qt_meta_data_FileUpload, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &FileUpload::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *FileUpload::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *FileUpload::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_FileUpload))
        return static_cast<void*>(const_cast< FileUpload*>(this));
    return QObject::qt_metacast(_clname);
}

int FileUpload::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
