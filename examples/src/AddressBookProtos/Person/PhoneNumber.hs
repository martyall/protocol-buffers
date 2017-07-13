{-# LANGUAGE BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module AddressBookProtos.Person.PhoneNumber (PhoneNumber(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified AddressBookProtos.Person.PhoneType as AddressBookProtos.Person (PhoneType)

data PhoneNumber = PhoneNumber{number :: !(P'.Utf8), type' :: !(P'.Maybe AddressBookProtos.Person.PhoneType)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

instance P'.Mergeable PhoneNumber where
  mergeAppend (PhoneNumber x'1 x'2) (PhoneNumber y'1 y'2) = PhoneNumber (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)

instance P'.Default PhoneNumber where
  defaultValue = PhoneNumber P'.defaultValue (Prelude'.Just (Prelude'.read "HOME"))

instance P'.Wire PhoneNumber where
  wireSize ft' self'@(PhoneNumber x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 9 x'1 + P'.wireSizeOpt 1 14 x'2)
  wirePut ft' self'@(PhoneNumber x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 10 9 x'1
             P'.wirePutOpt 16 14 x'2
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{number = new'Field}) (P'.wireGet 9)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{type' = Prelude'.Just new'Field}) (P'.wireGet 14)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> PhoneNumber) PhoneNumber where
  getVal m' f' = f' m'

instance P'.GPB PhoneNumber

instance P'.ReflectDescriptor PhoneNumber where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [10]) (P'.fromDistinctAscList [10, 16])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".tutorial.Person.PhoneNumber\", haskellPrefix = [], parentModule = [MName \"AddressBookProtos\",MName \"Person\"], baseName = MName \"PhoneNumber\"}, descFilePath = [\"AddressBookProtos\",\"Person\",\"PhoneNumber.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".tutorial.Person.PhoneNumber.number\", haskellPrefix' = [], parentModule' = [MName \"AddressBookProtos\",MName \"Person\",MName \"PhoneNumber\"], baseName' = FName \"number\", baseNamePrefix' = \"\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".tutorial.Person.PhoneNumber.type\", haskellPrefix' = [], parentModule' = [MName \"AddressBookProtos\",MName \"Person\",MName \"PhoneNumber\"], baseName' = FName \"type'\", baseNamePrefix' = \"\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 14}, typeName = Just (ProtoName {protobufName = FIName \".tutorial.Person.PhoneType\", haskellPrefix = [], parentModule = [MName \"AddressBookProtos\",MName \"Person\"], baseName = MName \"PhoneType\"}), hsRawDefault = Just \"HOME\", hsDefault = Just (HsDef'Enum \"HOME\")}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = False}"

instance P'.TextType PhoneNumber where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg PhoneNumber where
  textPut msg
   = do
       P'.tellT "number" (number msg)
       P'.tellT "type" (type' msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'number, parse'type']) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'number
         = P'.try
            (do
               v <- P'.getT "number"
               Prelude'.return (\ o -> o{number = v}))
        parse'type'
         = P'.try
            (do
               v <- P'.getT "type"
               Prelude'.return (\ o -> o{type' = v}))