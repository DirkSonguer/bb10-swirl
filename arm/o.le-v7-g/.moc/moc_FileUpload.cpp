/****************************************************************************
** Meta object code from reading C++ file 'FileUpload.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/FileUpload.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'FileUpload.hpp' doesn't include <QObject>."
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
       4,   14, // methods
       2,   34, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      19,   12,   11,   11, 0x05,
      57,   42,   11,   11, 0x05,

 // slots: signature, parameters, type, tag, flags
      97,   91,   11,   11, 0x08,

 // methods: signature, parameters, type, tag, flags
     165,  130,  125,   11, 0x02,

 // properties: name, type, flags
      12,  217, 0x0a495103,
      42,  225, 0x0c495103,

 // properties: notify_signal_id
       0,
       1,

       0        // eod
};

static const char qt_meta_stringdata_FileUpload[] = {
    "FileUpload\0\0source\0sourceChanged(QString)\0"
    "uploadResponse\0uploadResponseChanged(QByteArray)\0"
    "reply\0uploadReady(QNetworkReply*)\0"
    "bool\0checkinId,oauth_token,v,publicFlag\0"
    "upload(QByteArray,QByteArray,QByteArray,QByteArray)\0"
    "QString\0QByteArray\0"
};

void FileUpload::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        FileUpload *_t = static_cast<FileUpload *>(_o);
        switch (_id) {
        case 0: _t->sourceChanged((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 1: _t->uploadResponseChanged((*reinterpret_cast< const QByteArray(*)>(_a[1]))); break;
        case 2: _t->uploadReady((*reinterpret_cast< QNetworkReply*(*)>(_a[1]))); break;
        case 3: { bool _r = _t->upload((*reinterpret_cast< const QByteArray(*)>(_a[1])),(*reinterpret_cast< const QByteArray(*)>(_a[2])),(*reinterpret_cast< const QByteArray(*)>(_a[3])),(*reinterpret_cast< const QByteArray(*)>(_a[4])));
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
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = source(); break;
        case 1: *reinterpret_cast< QByteArray*>(_v) = uploadResponse(); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setSource(*reinterpret_cast< QString*>(_v)); break;
        case 1: setUploadResponse(*reinterpret_cast< QByteArray*>(_v)); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 2;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void FileUpload::sourceChanged(const QString & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void FileUpload::uploadResponseChanged(const QByteArray & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_END_MOC_NAMESPACE
